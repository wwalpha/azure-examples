# ----------------------------------------------------------------------------------------------
# Azure Virtual Machine - Windows Server 2016
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_machine" "win2016" {
  depends_on                       = [azurerm_network_interface_security_group_association.win2016]
  name                             = "win2016-${var.suffix}"
  location                         = var.resource_group_location
  resource_group_name              = var.resource_group_name
  vm_size                          = "Standard_B2ms"
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true
  network_interface_ids            = [azurerm_network_interface.win2016.id]

  identity {
    type = "SystemAssigned"
  }

  os_profile {
    computer_name  = "Windows2016"
    admin_username = var.azurevm_admin_username
    admin_password = var.azurevm_admin_password
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false
    timezone                  = "Tokyo Standard Time"
  }

  storage_os_disk {
    name              = "win2016${var.suffix}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
    os_type           = "Windows"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-datacenter-gensecond"
    version   = "latest"
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Machine Extension - Azure Monitor Agent
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_machine_extension" "win2016_azure_monitor" {
  name                       = "AzureMonitorWindowsAgent"
  virtual_machine_id         = azurerm_virtual_machine.win2016.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = false
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Machine Extension - Dependency Agent Windows
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_machine_extension" "win2016_dependency_agent" {
  name                       = "DependencyAgentWindows"
  virtual_machine_id         = azurerm_virtual_machine.win2016.id
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.10"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = false
}



