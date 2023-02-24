# ----------------------------------------------------------------------------------------------
# Azure Virtual Network
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network" "this" {
  name                = "vm-vnet-${var.suffix}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = ["10.10.0.0/16"]
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Network Subnet
# ----------------------------------------------------------------------------------------------
resource "azurerm_subnet" "this" {
  name                 = "vm-subnet-${var.suffix}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.10.1.0/24"]
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Network Security Group
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_security_group" "this" {
  name                = "vm-sg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}
