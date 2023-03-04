# ----------------------------------------------------------------------------------------------
# Azure Virtual Machine Network Security Group
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_security_group" "this" {
  name                = "vm-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

# ----------------------------------------------------------------------------------------------
# Azure Network Security Rule
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_security_rule" "this" {
  name                        = "AllowInbound"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefix       = "Internet"
  destination_port_range      = "80"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
}

# ----------------------------------------------------------------------------------------------
# Azure Network Interface - Windows Server 2016
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface" "win2016" {
  name                = "win2016-nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.vnet_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Network Interface - Windows Server 2022
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface" "win2022" {
  name                = "win2022-nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.vnet_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Network Interface - RHEL 8.6
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface" "rhel_86" {
  name                = "rhel86-nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.vnet_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Network Interface - Ubuntu
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface" "ubuntu" {
  name                = "ubuntu-nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.vnet_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Network Interface Security Group Association
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface_security_group_association" "win2016" {
  network_interface_id      = azurerm_network_interface.win2016.id
  network_security_group_id = azurerm_network_security_group.this.id
}

# ----------------------------------------------------------------------------------------------
# Azure Network Interface Security Group Association
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface_security_group_association" "win2022" {
  network_interface_id      = azurerm_network_interface.win2022.id
  network_security_group_id = azurerm_network_security_group.this.id
}

# ----------------------------------------------------------------------------------------------
# Azure Network Interface Security Group Association
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface_security_group_association" "rhel_86" {
  network_interface_id      = azurerm_network_interface.rhel_86.id
  network_security_group_id = azurerm_network_security_group.this.id
}

# ----------------------------------------------------------------------------------------------
# Azure Network Interface Security Group Association
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface_security_group_association" "ubuntu" {
  network_interface_id      = azurerm_network_interface.ubuntu.id
  network_security_group_id = azurerm_network_security_group.this.id
}
