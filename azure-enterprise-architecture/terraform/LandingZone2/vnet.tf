# ----------------------------------------------------------------------------------------------
# Azure Virtual Network
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network" "this" {
  name                = "vnet-spoke2-${var.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.vnet_address]
}

# ----------------------------------------------------------------------------------------------
# Azure Subnet
# ----------------------------------------------------------------------------------------------
resource "azurerm_subnet" "this" {
  count                = length(var.subnet_address)
  name                 = "subnet${count.index}-${var.suffix}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_address[count.index]]
}
