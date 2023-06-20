# ----------------------------------------------------------------------------------------------
# Azure Network Security Group - VM1
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_security_group" "vm1" {
  name                = "vm1-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

# ----------------------------------------------------------------------------------------------
# Azure Network Internet - VM1
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface" "vm1" {
  name                = "vm1-nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.vm1_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Network Internet Security Group Association - VM1
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface_security_group_association" "vm1" {
  network_interface_id      = azurerm_network_interface.vm1.id
  network_security_group_id = azurerm_network_security_group.vm1.id
}

# ----------------------------------------------------------------------------------------------
# Azure Network Security Group - VM2
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_security_group" "vm2" {
  name                = "vm2-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

# ----------------------------------------------------------------------------------------------
# Azure Network Internet - VM2
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface" "vm2" {
  name                = "vm2-nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.vm2_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Network Internet Security Group Association - VM2
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface_security_group_association" "vm2" {
  network_interface_id      = azurerm_network_interface.vm2.id
  network_security_group_id = azurerm_network_security_group.vm2.id
}
