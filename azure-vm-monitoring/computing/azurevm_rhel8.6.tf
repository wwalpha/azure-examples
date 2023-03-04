# ----------------------------------------------------------------------------------------------
# Azure Virtual Machine - Redhat Linux Enterprise 8.6
# ----------------------------------------------------------------------------------------------
resource "azurerm_linux_virtual_machine" "rhel_86" {
  depends_on                      = [azurerm_network_interface_security_group_association.rhel_86]
  name                            = "rhel86-${var.suffix}"
  location                        = var.resource_group_location
  resource_group_name             = var.resource_group_name
  network_interface_ids           = [azurerm_network_interface.rhel_86.id]
  size                            = "Standard_B2ms"
  disable_password_authentication = false
  computer_name                   = "RHEL86"
  admin_username                  = var.azurevm_admin_username
  admin_password                  = var.azurevm_admin_password
  custom_data                     = filebase64("${path.module}/scripts/rhel-cloud-init.yml")

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "86-gen2"
    version   = "latest"
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Machine Extension - Azure Monitor Agent
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_machine_extension" "rhel86_azure_monitor" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.rhel_86.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = false
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Machine Extension - Dependency Agent Linux
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_machine_extension" "rhel86_dependency_agent" {
  name                       = "DependencyAgentLinux"
  virtual_machine_id         = azurerm_linux_virtual_machine.rhel_86.id
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentLinux"
  type_handler_version       = "9.10"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = false
}
