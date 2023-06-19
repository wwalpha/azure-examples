resource "azurerm_network_security_group" "agent" {
  name                = "agent-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_interface" "agent" {
  name                = "agent-nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.agent_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "agent" {
  network_interface_id      = azurerm_network_interface.agent.id
  network_security_group_id = azurerm_network_security_group.agent.id
}

resource "azurerm_network_security_group" "target" {
  name                = "target-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_interface" "target" {
  name                = "target-nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.agent_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "target" {
  network_interface_id      = azurerm_network_interface.target.id
  network_security_group_id = azurerm_network_security_group.target.id
}
