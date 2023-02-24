resource "azurerm_virtual_network" "agent" {
  name                = "agent-vnet-${var.suffix}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "agent" {
  name                 = "AgentSubnet-${var.suffix}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.agent.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.agent.name
  address_prefixes     = ["10.0.0.0/24"]
}
