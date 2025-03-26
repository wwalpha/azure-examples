# ----------------------------------------------------------------------------------------------
# Azure Virtual Network
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network" "this" {
  name                = "vnet-spoke1-${var.suffix}"
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

# ----------------------------------------------------------------------------------------------
# Azure Virtual Hub Connection
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_hub_connection" "this" {
  name                      = "landingzone1-to-hub"
  virtual_hub_id            = var.virtual_hub_id
  remote_virtual_network_id = azurerm_virtual_network.this.id
  internet_security_enabled = true
}
