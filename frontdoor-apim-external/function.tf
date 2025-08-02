# ----------------------------------------------------------------------------------------------
# Azure Service Plan
# ----------------------------------------------------------------------------------------------
resource "azurerm_service_plan" "function" {
  name                = "asp-${var.project_name}-${var.environment}-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = var.function_app_sku
  tags                = local.common_tags
}

# ----------------------------------------------------------------------------------------------
# Azure Function App - Linux
# ----------------------------------------------------------------------------------------------
resource "azurerm_linux_function_app" "main" {
  name                       = "func-${var.project_name}-${var.environment}-${local.resource_suffix}"
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  service_plan_id            = azurerm_service_plan.function.id
  storage_account_name       = azurerm_storage_account.function.name
  storage_account_access_key = azurerm_storage_account.function.primary_access_key

  virtual_network_subnet_id = azurerm_subnet.function.id

  site_config {
    application_stack {
      node_version = "22"
    }

    # Enable VNET integration
    vnet_route_all_enabled = true

    # Allow access from APIM subnet and public access for testing
    # ip_restriction {
    #   action                    = "Allow"
    #   priority                  = 100
    #   name                      = "AllowAPIMSubnet"
    #   virtual_network_subnet_id = azurerm_subnet.apim.id
    # }

    # Temporarily allow all access for debugging
    ip_restriction {
      action     = "Deny"
      priority   = 200
      name       = "DenyAll"
      ip_address = "0.0.0.0/0"
    }
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"                 = "node"
    # "WEBSITE_NODE_DEFAULT_VERSION"             = "~22"
    "WEBSITE_RUN_FROM_PACKAGE"            = "1"
    # "FUNCTIONS_EXTENSION_VERSION"              = "~4"
    "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = azurerm_storage_account.function.primary_connection_string
    "WEBSITE_CONTENTSHARE"                     = "func-${var.project_name}-${var.environment}-${local.resource_suffix}-content"
    # "WEBSITE_VNET_ROUTE_ALL"                   = "1"
    "WEBSITE_DNS_SERVER"                       = "168.63.129.16"
    # Add storage connection for managed identity
    # "AzureWebJobsStorage__accountName"         = azurerm_storage_account.function.name
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

# Private Endpoint for Function App
resource "azurerm_private_endpoint" "function" {
  name                = "pe-func-${var.environment}-${local.resource_suffix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = "psc-func-${var.environment}-${local.resource_suffix}"
    private_connection_resource_id = azurerm_linux_function_app.main.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-group-func"
    private_dns_zone_ids = [azurerm_private_dns_zone.function.id]
  }

  tags = local.common_tags
}

# Private DNS Zone for Function App
resource "azurerm_private_dns_zone" "function" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags
}

# Link Private DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "function" {
  name                  = "pdz-link-func-${var.environment}-${local.resource_suffix}"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.function.name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled  = false
  tags                  = local.common_tags
}

# Private Endpoint for Storage Account
resource "azurerm_private_endpoint" "storage" {
  name                = "pe-st-${var.environment}-${local.resource_suffix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = "psc-st-${var.environment}-${local.resource_suffix}"
    private_connection_resource_id = azurerm_storage_account.function.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-group-storage"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage.id]
  }

  tags = local.common_tags
}

# Private DNS Zone for Storage Account
resource "azurerm_private_dns_zone" "storage" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags
}

# Link Storage Private DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "storage" {
  name                  = "pdz-link-st-${var.environment}-${local.resource_suffix}"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.storage.name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled  = false
  tags                  = local.common_tags
}
