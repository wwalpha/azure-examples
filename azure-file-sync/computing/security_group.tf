# ----------------------------------------------------------------------------------------------
# Azure Network Security Group - Public Server
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_security_group" "public" {
  name                = "public-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

# ----------------------------------------------------------------------------------------------
# Azure Network Internet - Public Server
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface" "public" {
  name                = "public-nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.public_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Network Internet Security Group Association - Public Server
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface_security_group_association" "public" {
  network_interface_id      = azurerm_network_interface.public.id
  network_security_group_id = azurerm_network_security_group.public.id
}

# ----------------------------------------------------------------------------------------------
# Azure Network Security Group - Private Server
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_security_group" "private" {
  name                = "private-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "DenyAnyInternetOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Network Internet - Private Server
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface" "private" {
  name                = "private-nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.private_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Network Internet Security Group Association - Private Server
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface_security_group_association" "private" {
  network_interface_id      = azurerm_network_interface.private.id
  network_security_group_id = azurerm_network_security_group.private.id
}
