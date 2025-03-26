# ----------------------------------------------------------------------------------------------
# Azure Virtual Network Gateway - VPN
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network_gateway" "connectivity_vpn_gateway" {
  name                = "connectivity-vpn-gateway"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = false
  enable_bgp          = false
  sku                 = "VpnGw2"

  ip_configuration {
    name                 = "vpn-gateway-config"
    public_ip_address_id = azurerm_public_ip.connectivity_vpn_gateway_pip.id
    subnet_id            = azurerm_subnet.gateway.id
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Public IP - VPN
# ----------------------------------------------------------------------------------------------
resource "azurerm_public_ip" "connectivity_vpn_gateway_pip" {
  name                = "connectivity-vpn-gateway-pip"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Dynamic"
}
