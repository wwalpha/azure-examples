# ----------------------------------------------------------------------------------------------
# Azure Virtual Network - Public(Internet)
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network" "public" {
  name                = "vnet-public-${var.suffix}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = ["10.1.0.0/16"]
}

# ----------------------------------------------------------------------------------------------
# Azure Subnet - Public(Internet)
# ----------------------------------------------------------------------------------------------
resource "azurerm_subnet" "public" {
  name                 = "PublicSubnet-${var.suffix}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.public.name
  address_prefixes     = ["10.1.1.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

# ----------------------------------------------------------------------------------------------
# Azure Subnet - Gateway
# ----------------------------------------------------------------------------------------------
# resource "azurerm_subnet" "public_gateway" {
#   name                 = "GatewaySubnet"
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = azurerm_virtual_network.public.name
#   address_prefixes     = ["10.1.0.0/24"]
# }

# ----------------------------------------------------------------------------------------------
# Azure Virtual Network - Private
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network" "private" {
  name                = "vnet-private-${var.suffix}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = ["10.2.0.0/16"]
}

# ----------------------------------------------------------------------------------------------
# Azure Subnet - Private
# ----------------------------------------------------------------------------------------------
resource "azurerm_subnet" "private" {
  name                 = "PrivateSubnet-${var.suffix}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.private.name
  address_prefixes     = ["10.2.1.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

# ----------------------------------------------------------------------------------------------
# Azure Subnet - Gateway
# ----------------------------------------------------------------------------------------------
# resource "azurerm_subnet" "private_gateway" {
#   name                 = "GatewaySubnet"
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = azurerm_virtual_network.private.name
#   address_prefixes     = ["10.2.0.0/24"]
# }

# ----------------------------------------------------------------------------------------------
# Azure Virtual Network - VPN
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network" "vpn" {
  name                = "vnet-vpn-${var.suffix}"
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
# Azure Virtual Network Peering - Public to VPN Peering
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network_peering" "public_vpn_peer" {
  depends_on                   = [azurerm_virtual_network.vpn, azurerm_virtual_network.public]
  name                         = "public-vpn-peer"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.public.name
  remote_virtual_network_id    = azurerm_virtual_network.vpn.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Network Peering - VPN to Public Peering
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network_peering" "vpn_public_peer" {
  depends_on                   = [azurerm_virtual_network.vpn, azurerm_virtual_network.public]
  name                         = "vpn-public-peer"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.vpn.name
  remote_virtual_network_id    = azurerm_virtual_network.public.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

# # ----------------------------------------------------------------------------------------------
# # Azure Virtual Network Peering - Private VPN Peering
# # ----------------------------------------------------------------------------------------------
# resource "azurerm_virtual_network_peering" "private_vpn_peer" {
#   depends_on                   = [azurerm_virtual_network.vpn, azurerm_virtual_network.private]
#   name                         = "private-vpn-peer"
#   resource_group_name          = var.resource_group_name
#   virtual_network_name         = azurerm_virtual_network.private.name
#   remote_virtual_network_id    = azurerm_virtual_network.vpn.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = false
#   use_remote_gateways          = true
# }

# # ----------------------------------------------------------------------------------------------
# # Azure Virtual Network Peering - VPN to Private Peering
# # ----------------------------------------------------------------------------------------------
# resource "azurerm_virtual_network_peering" "vpn_private_peer" {
#   depends_on                   = [azurerm_virtual_network.vpn, azurerm_virtual_network.private]
#   name                         = "vpn-private-peer"
#   resource_group_name          = var.resource_group_name
#   virtual_network_name         = azurerm_virtual_network.vpn.name
#   remote_virtual_network_id    = azurerm_virtual_network.private.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = true
#   use_remote_gateways          = false
# }
