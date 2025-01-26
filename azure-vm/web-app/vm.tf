# ----------------------------------------------------------------------------------------------
# Azure Network Interface
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface" "backend" {
  count               = 2
  name                = "NIC${count.index + 1}-${local.suffix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  ip_configuration {
    name                          = "nic-ipconfig-${count.index + 1}"
    subnet_id                     = azurerm_subnet.backend.id
    private_ip_address_allocation = "Dynamic"
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Linux Virtual Machine
# ----------------------------------------------------------------------------------------------
resource "azurerm_linux_virtual_machine" "this" {
  count                           = 2
  name                            = "Backend${count.index + 1}-${local.suffix}"
  resource_group_name             = azurerm_resource_group.this.name
  location                        = azurerm_resource_group.this.location
  size                            = "Standard_B2ms"
  admin_username                  = "azureuser"
  admin_password                  = random_password.password.result
  disable_password_authentication = false
  zone                            = count.index + 1

  network_interface_ids = [
    azurerm_network_interface.backend[count.index].id,
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

  user_data = base64encode(local.vm_user_data)
}
