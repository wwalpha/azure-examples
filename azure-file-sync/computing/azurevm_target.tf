resource "azurerm_virtual_machine" "target" {
  depends_on                       = [azurerm_network_interface_security_group_association.target]
  name                             = "filesync-target-${var.suffix}"
  location                         = var.resource_group_location
  resource_group_name              = var.resource_group_name
  vm_size                          = "Standard_B2ms"
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true
  network_interface_ids            = [azurerm_network_interface.target.id]

  os_profile {
    computer_name  = "FileSyncTarget"
    admin_username = var.azurevm_admin_username
    admin_password = var.azurevm_admin_password
  }

  os_profile_windows_config {
    provision_vm_agent        = false
    enable_automatic_upgrades = false
    timezone                  = "Tokyo Standard Time"
  }

  storage_os_disk {
    name              = "FileSyncTarget${var.suffix}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
    os_type           = "Windows"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
}

resource "azurerm_managed_disk" "target" {
  name                 = "filesync-target-disk"
  location             = var.resource_group_location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 100
}

resource "azurerm_virtual_machine_data_disk_attachment" "target" {
  managed_disk_id    = azurerm_managed_disk.target.id
  virtual_machine_id = azurerm_virtual_machine.target.id
  lun                = "10"
  caching            = "ReadWrite"
}
