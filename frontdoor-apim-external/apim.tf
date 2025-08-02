# Public IP for APIM (required for external access)
resource "azurerm_public_ip" "apim" {
  name                = "pip-apim-${var.environment}-${local.resource_suffix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "apim-${var.project_name}-${var.environment}-${local.resource_suffix}"
  tags                = local.common_tags
}

# API Management
resource "azurerm_api_management" "main" {
  name                = "apim-${var.project_name}-${var.environment}-${local.resource_suffix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = var.apim_sku_name

  # External VNET configuration
  virtual_network_type = "External"
  virtual_network_configuration {
    subnet_id = azurerm_subnet.apim.id
  }

  # Additional configuration
  public_ip_address_id = azurerm_public_ip.apim.id

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

# APIM API for Function App
resource "azurerm_api_management_api" "function" {
  name                = "function-api"
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  revision            = "1"
  display_name        = "Function API"
  protocols           = ["https"]
  service_url         = "https://${azurerm_linux_function_app.main.default_hostname}"
  subscription_required = false

  import {
    content_format = "openapi+json"
    content_value = jsonencode({
      openapi = "3.0.1"
      info = {
        title   = "Function API"
        version = "1.0"
      }
      servers = [
        {
          url = "https://${azurerm_linux_function_app.main.default_hostname}"
        }
      ]
      paths = {
        "/api/httpget" = {
          get = {
            operationId = "get-httpget"
            responses = {
              "200" = {
                description = "Success"
              }
            }
          }
        }
      }
    })
  }
}

# APIM Backend for Function App
resource "azurerm_api_management_backend" "function" {
  name                = "function-backend"
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  protocol            = "http"
  url                 = "https://${azurerm_linux_function_app.main.default_hostname}"

  credentials {
    header = {
      "x-functions-key" = "{{function-key}}"
    }
  }
}

# Get Function App host keys
data "azurerm_function_app_host_keys" "function" {
  name                = azurerm_linux_function_app.main.name
  resource_group_name = azurerm_resource_group.main.name
  depends_on          = [azurerm_linux_function_app.main]
}

# APIM Named Value for Function Key
resource "azurerm_api_management_named_value" "function_key" {
  name                = "function-key"
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  display_name        = "function-key"
  value               = data.azurerm_function_app_host_keys.function.default_function_key
  secret              = true
}

# APIM API Operation
# resource "azurerm_api_management_api_operation" "get_httpget" {
#   operation_id        = "get-httpget-v2"
#   api_name            = azurerm_api_management_api.function.name
#   api_management_name = azurerm_api_management.main.name
#   resource_group_name = azurerm_resource_group.main.name
#   display_name        = "GET httpget"
#   method              = "GET"
#   url_template        = "/httpget"

# }

# APIM API Policy
resource "azurerm_api_management_api_policy" "function" {
  api_name            = azurerm_api_management_api.function.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name

  xml_content = <<XML
<policies>
  <inbound>
    <base />
    <set-backend-service backend-id="function-backend" />
    <set-header name="X-Debug-Original-URI" exists-action="override">
      <value>@(context.Request.Url.Path)</value>
    </set-header>
    <cors allow-credentials="false">
      <allowed-origins>
        <origin>*</origin>
      </allowed-origins>
      <allowed-methods>
        <method>GET</method>
        <method>POST</method>
        <method>PUT</method>
        <method>DELETE</method>
        <method>OPTIONS</method>
      </allowed-methods>
      <allowed-headers>
        <header>*</header>
      </allowed-headers>
    </cors>
  </inbound>
  <backend>
    <base />
  </backend>
  <outbound>
    <base />
  </outbound>
  <on-error>
    <base />
  </on-error>
</policies>
XML
}
