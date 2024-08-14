# ----------------------------------------------------------------------------------------------
# Azure Virtual Network
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network" "this" {
  name                = "vnet-${local.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["172.16.0.0/16"]
}

# ----------------------------------------------------------------------------------------------
# Azure Subnet
# ----------------------------------------------------------------------------------------------
resource "azurerm_subnet" "this" {
  name                 = "PrivateSubnet-${local.suffix}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["172.16.1.0/24"]
}

# ----------------------------------------------------------------------------------------------
# Azure Subnet - Gateway
# ----------------------------------------------------------------------------------------------
resource "azurerm_subnet" "vpngw" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["172.16.0.0/24"]
}
