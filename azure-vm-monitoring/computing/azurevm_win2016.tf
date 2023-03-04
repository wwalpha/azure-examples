# ----------------------------------------------------------------------------------------------
# Azure Virtual Machine - Windows Server 2016
# ----------------------------------------------------------------------------------------------
resource "azurerm_windows_virtual_machine" "win2016" {
  depends_on               = [azurerm_network_interface_security_group_association.win2016]
  name                     = "win2016-${var.suffix}"
  location                 = var.resource_group_location
  resource_group_name      = var.resource_group_name
  size                     = "Standard_B2ms"
  computer_name            = "Windows2016"
  admin_username           = var.azurevm_admin_username
  admin_password           = var.azurevm_admin_password
  network_interface_ids    = [azurerm_network_interface.win2016.id]
  enable_automatic_updates = true
  timezone                 = "Tokyo Standard Time"

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
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
  virtual_machine_id         = azurerm_windows_virtual_machine.win2016.id
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
  virtual_machine_id         = azurerm_windows_virtual_machine.win2016.id
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.10"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = false
}



