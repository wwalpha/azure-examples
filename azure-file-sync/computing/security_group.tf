# ----------------------------------------------------------------------------------------------
# Azure Network Security Group - Public Server
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_security_group" "public_active" {
  name                = "public-active-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

# ----------------------------------------------------------------------------------------------
# Azure Network Internet - Public Server
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface" "public_active" {
  name                = "public-active-nic"
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
resource "azurerm_network_interface_security_group_association" "public_active" {
  network_interface_id      = azurerm_network_interface.public_active.id
  network_security_group_id = azurerm_network_security_group.public_active.id
}


# ----------------------------------------------------------------------------------------------
# Azure Network Security Group - Public Server
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_security_group" "public_standby" {
  name                = "public-stanby-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

# ----------------------------------------------------------------------------------------------
# Azure Network Internet - Public Server
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface" "public_standby" {
  name                = "public-stanby-nic"
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
resource "azurerm_network_interface_security_group_association" "public_standby" {
  network_interface_id      = azurerm_network_interface.public_standby.id
  network_security_group_id = azurerm_network_security_group.public_standby.id
}



# ----------------------------------------------------------------------------------------------
# Azure Network Security Group - Private Server
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_security_group" "private" {
  name                = "private-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowHttpsOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "DenyAnyInternetOutbound"
    priority                   = 1000
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
