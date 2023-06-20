# ----------------------------------------------------------------------------------------------
# Azure Virtual Machine - Private Server
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_machine" "vm2" {
  depends_on                       = [azurerm_network_interface_security_group_association.vm2]
  name                             = "peering-vm2-${var.suffix}"
  location                         = var.resource_group_location
  resource_group_name              = var.resource_group_name
  vm_size                          = "Standard_B2ms"
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true
  network_interface_ids            = [azurerm_network_interface.vm2.id]

  os_profile {
    computer_name  = "PeeringVM2"
    admin_username = var.azurevm_admin_username
    admin_password = var.azurevm_admin_password
  }

  os_profile_windows_config {
    provision_vm_agent        = false
    enable_automatic_upgrades = false
    timezone                  = "Tokyo Standard Time"
  }

  storage_os_disk {
    name              = "PeeringVM2${var.suffix}"
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

# ----------------------------------------------------------------------------------------------
# Azure Managed Disk - Private Server
# ----------------------------------------------------------------------------------------------
resource "azurerm_managed_disk" "vm2" {
  name                 = "peering-vm2-disk"
  location             = var.resource_group_location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 100
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Machine Data Disk Attachment - Private Server
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_machine_data_disk_attachment" "vm2" {
  managed_disk_id    = azurerm_managed_disk.vm2.id
  virtual_machine_id = azurerm_virtual_machine.vm2.id
  lun                = "10"
  caching            = "ReadWrite"
}
