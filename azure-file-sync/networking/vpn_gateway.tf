resource "azurerm_public_ip" "vpngw" {
  name                = "vpngw-ip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

data "azurerm_client_config" "this" {}

resource "azurerm_virtual_network_gateway" "this" {
  name                = "vpngw-${var.suffix}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "GatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpngw.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway.id
  }

  vpn_client_configuration {
    address_space        = ["172.168.0.0/24"]
    vpn_auth_types       = ["AAD"]
    vpn_client_protocols = ["OpenVPN"]
    aad_tenant           = "https://login.microsoftonline.com/${var.tenant_id}"
    aad_audience         = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
    aad_issuer           = "https://sts.windows.net/${var.tenant_id}/"
  }
}
