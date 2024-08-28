# ----------------------------------------------------------------------------------------------
# Public IP
# ----------------------------------------------------------------------------------------------
resource "azurerm_public_ip" "vpngw" {
  name                = "vpngw-${local.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# ----------------------------------------------------------------------------------------------
# Virtual Network Gateway - Site to Site VPN
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network_gateway" "this" {
  name                = "vpngw-${local.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = false
  enable_bgp          = false
  sku                 = "VpnGw1"

  ip_configuration {
    name                          = "GatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpngw.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.vpngw.id
  }
}

# ----------------------------------------------------------------------------------------------
# Local Network Gateway - Site to Site VPN
# ----------------------------------------------------------------------------------------------
resource "azurerm_local_network_gateway" "this" {
  count               = var.aws_virtual_private_gateway_public_ip == "" ? 0 : 1
  name                = "aws-vpgw-${local.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  gateway_address     = var.aws_virtual_private_gateway_public_ip
  address_space       = [var.aws_address_spaces]
}

# ----------------------------------------------------------------------------------------------
# Local Network Gateway - Site to Site VPN
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network_gateway_connection" "this" {
  count                      = var.aws_virtual_private_gateway_public_ip == "" ? 0 : 1
  depends_on                 = [azurerm_local_network_gateway.this, azurerm_virtual_network_gateway.this]
  name                       = "aws-s2s-azure-${local.suffix}"
  location                   = azurerm_resource_group.this.location
  resource_group_name        = azurerm_resource_group.this.name
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.this.id
  local_network_gateway_id   = azurerm_local_network_gateway.this[0].id
  shared_key                 = var.pre_shared_key
}
