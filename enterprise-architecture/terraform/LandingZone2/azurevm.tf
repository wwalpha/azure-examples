# ----------------------------------------------------------------------------------------------
# Azure Network Interface
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface" "this" {
  name                = "Server01NIC-${var.suffix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  ip_configuration {
    name                          = "server01nic-ipconfig"
    subnet_id                     = azurerm_subnet.this[0].id
    private_ip_address_allocation = "Dynamic"
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Linux Virtual Machine
# ----------------------------------------------------------------------------------------------
resource "azurerm_linux_virtual_machine" "this" {
  name                            = "server01-${var.suffix}"
  resource_group_name             = azurerm_resource_group.this.name
  location                        = azurerm_resource_group.this.location
  size                            = "Standard_B2s"
  admin_username                  = "azureuser"
  admin_password                  = var.vm_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.this.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
