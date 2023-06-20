# ----------------------------------------------------------------------------------------------
# Azure Virtual Machine - Public Server
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_machine" "public_active" {
  depends_on                       = [azurerm_network_interface_security_group_association.public_active]
  name                             = "filesync-public-active-${var.suffix}"
  location                         = var.resource_group_location
  resource_group_name              = var.resource_group_name
  vm_size                          = "Standard_B2ms"
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true
  network_interface_ids            = [azurerm_network_interface.public_active.id]

  os_profile {
    computer_name  = "FileSyncActive"
    admin_username = var.azurevm_admin_username
    admin_password = var.azurevm_admin_password
  }

  os_profile_windows_config {
    provision_vm_agent        = false
    enable_automatic_upgrades = false
    timezone                  = "Tokyo Standard Time"
  }

  storage_os_disk {
    name              = "FileSyncPublicActive${var.suffix}"
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
# Azure Managed Disk - Public Server
# ----------------------------------------------------------------------------------------------
resource "azurerm_managed_disk" "public_active" {
  name                 = "filesync-public-active-disk"
  location             = var.resource_group_location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 100
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Machine Data Disk Attachment - Public Server
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_machine_data_disk_attachment" "public_active" {
  managed_disk_id    = azurerm_managed_disk.public_active.id
  virtual_machine_id = azurerm_virtual_machine.public_active.id
  lun                = "10"
  caching            = "ReadWrite"
}


# ----------------------------------------------------------------------------------------------
# Azure Virtual Machine - Public Server
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_machine" "public_standby" {
  depends_on                       = [azurerm_network_interface_security_group_association.public_standby]
  name                             = "filesync-public-standby-${var.suffix}"
  location                         = var.resource_group_location
  resource_group_name              = var.resource_group_name
  vm_size                          = "Standard_B2ms"
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true
  network_interface_ids            = [azurerm_network_interface.public_standby.id]

  os_profile {
    computer_name  = "FileSyncStandby"
    admin_username = var.azurevm_admin_username
    admin_password = var.azurevm_admin_password
  }

  os_profile_windows_config {
    provision_vm_agent        = false
    enable_automatic_upgrades = false
    timezone                  = "Tokyo Standard Time"
  }

  storage_os_disk {
    name              = "FileSyncPublicStandby${var.suffix}"
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
# Azure Managed Disk - Public Server
# ----------------------------------------------------------------------------------------------
resource "azurerm_managed_disk" "public_standby" {
  name                 = "filesync-public-standby-disk"
  location             = var.resource_group_location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 100
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Machine Data Disk Attachment - Public Server
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_machine_data_disk_attachment" "public_standby" {
  managed_disk_id    = azurerm_managed_disk.public_standby.id
  virtual_machine_id = azurerm_virtual_machine.public_standby.id
  lun                = "10"
  caching            = "ReadWrite"
}
