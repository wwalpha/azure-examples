# ----------------------------------------------------------------------------------------------
# Azure Virtual Network - VNet1
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1-${var.suffix}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = ["10.1.0.0/16"]
}

# ----------------------------------------------------------------------------------------------
# Azure Subnet - VNet1
# ----------------------------------------------------------------------------------------------
resource "azurerm_subnet" "vnet1" {
  name                 = "VNetSubnet1-${var.suffix}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.1.1.0/24"]
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Network - VNet2
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network" "vnet2" {
  name                = "vnet-private-${var.suffix}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = ["10.2.0.0/16"]
}

# ----------------------------------------------------------------------------------------------
# Azure Subnet - Private
# ----------------------------------------------------------------------------------------------
resource "azurerm_subnet" "vnet2" {
  name                 = "VNetSubnet2-${var.suffix}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.2.1.0/24"]
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Network - VPN
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network" "vpn" {
  name                = "vnetvpn-${var.suffix}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

# ----------------------------------------------------------------------------------------------
# Azure Subnet - Gateway
# ----------------------------------------------------------------------------------------------
resource "azurerm_subnet" "vpn_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vpn.name
  address_prefixes     = ["10.0.0.0/24"]
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Network Peering - VNet1 to VPN Peering
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network_peering" "vnet1_vpn_peer" {
  depends_on                   = [azurerm_virtual_network.vpn, azurerm_virtual_network.vnet1, azurerm_virtual_network_gateway.this]
  name                         = "vnet1-vpn-peer"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id    = azurerm_virtual_network.vpn.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Network Peering - VPN to VNet1 Peering
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network_peering" "vpn_vnet1_peer" {
  depends_on                   = [azurerm_virtual_network.vpn, azurerm_virtual_network.vnet1, azurerm_virtual_network_gateway.this]
  name                         = "vpn-vnet1-peer"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.vpn.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Network Peering - VNet2 to VPN Peering
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network_peering" "vnet2_vpn_peer" {
  depends_on                   = [azurerm_virtual_network.vpn, azurerm_virtual_network.vnet2, azurerm_virtual_network_gateway.this]
  name                         = "vnet2-vpn-peer"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id    = azurerm_virtual_network.vpn.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Network Peering - VPN to VNet2 Peering
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network_peering" "vpn_vnet2_peer" {
  depends_on                   = [azurerm_virtual_network.vpn, azurerm_virtual_network.vnet2, azurerm_virtual_network_gateway.this]
  name                         = "vpn-vnet2-peer"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.vpn.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}
