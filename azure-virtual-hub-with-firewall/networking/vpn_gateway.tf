data "azurerm_client_config" "this" {}

resource "azurerm_vpn_server_configuration" "this" {
  name                     = "vpn-config"
  location                 = var.resource_group_location
  resource_group_name      = var.resource_group_name
  vpn_authentication_types = ["AAD"]
  vpn_protocols            = ["OpenVPN"]

  azure_active_directory_authentication {
    tenant   = "https://login.microsoftonline.com/${data.azurerm_client_config.this.tenant_id}"
    audience = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
    issuer   = "https://sts.windows.net/${data.azurerm_client_config.this.tenant_id}/"
  }
}

resource "azurerm_point_to_site_vpn_gateway" "this" {
  name                        = "p2s-vpngw-${var.suffix}"
  location                    = var.resource_group_location
  resource_group_name         = var.resource_group_name
  vpn_server_configuration_id = azurerm_vpn_server_configuration.this.id
  virtual_hub_id              = azurerm_virtual_hub.this.id
  scale_unit                  = 1

  connection_configuration {
    name = "connection-config"

    vpn_client_address_pool {
      address_prefixes = [
        "172.16.0.0/24"
      ]
    }
  }
}
