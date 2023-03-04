# ----------------------------------------------------------------------------------------------
# Azure Virtual Machine - Redhat Linux Enterprise 8.6
# ----------------------------------------------------------------------------------------------
resource "azurerm_linux_virtual_machine" "ubuntu" {
  depends_on                      = [azurerm_network_interface_security_group_association.ubuntu]
  name                            = "ubuntu-2004-${var.suffix}"
  location                        = var.resource_group_location
  resource_group_name             = var.resource_group_name
  network_interface_ids           = [azurerm_network_interface.ubuntu.id]
  size                            = "Standard_B2ms"
  computer_name                   = "Ubuntu2004"
  disable_password_authentication = false
  admin_username                  = var.azurevm_admin_username
  admin_password                  = var.azurevm_admin_password
  custom_data                     = filebase64("${path.module}/scripts/ubuntu-cloud-init.yml")
  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Machine Extension - Azure Monitor Agent
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_machine_extension" "ubuntu_azure_monitor" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.ubuntu.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = false
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Machine Extension - Dependency Agent Linux
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_machine_extension" "ubuntu_dependency_agent" {
  name                       = "DependencyAgentLinux"
  virtual_machine_id         = azurerm_linux_virtual_machine.ubuntu.id
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentLinux"
  type_handler_version       = "9.10"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = false
  settings = jsonencode(
    {
      enableAMA = "true"
    }
  )
}
