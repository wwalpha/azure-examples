# ----------------------------------------------------------------------------------------------
# Azure Virtual Network
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network" "this" {
  name                = "VNet-${local.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.0.0/16"]
}

# ----------------------------------------------------------------------------------------------
# Azure Subnet - Frontend
# ----------------------------------------------------------------------------------------------
resource "azurerm_subnet" "frontend" {
  name                 = "ApplicationGatewaySubnet-${local.suffix}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]
}

# ----------------------------------------------------------------------------------------------
# Azure Subnet - Backend
# ----------------------------------------------------------------------------------------------
resource "azurerm_subnet" "backend" {
  name                 = "BackendSubnet-${local.suffix}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.2.0/24"]
}
