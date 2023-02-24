# ----------------------------------------------------------------------------------------------
# Azure Virtual Machine - Redhat Linux Enterprise 8.6
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_machine" "ubuntu" {
  depends_on                       = [azurerm_network_interface_security_group_association.ubuntu]
  name                             = "ubuntu-1804-${var.suffix}"
  location                         = var.resource_group_location
  resource_group_name              = var.resource_group_name
  vm_size                          = "Standard_B2ms"
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true
  network_interface_ids            = [azurerm_network_interface.ubuntu.id]

  identity {
    type = "SystemAssigned"
  }

  os_profile {
    computer_name  = "Ubuntu1804"
    admin_username = var.azurevm_admin_username
    admin_password = var.azurevm_admin_password
    # custom_data    = <<-EOF
    #   #cloud-config
    #   package_upgrade: true
    #   packages:
    #     - nginx
    #   runcmd:
    #     - service nginx restart
    # EOF
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  storage_os_disk {
    name              = "Ubuntu${var.suffix}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18_04-lts-gen2"
    version   = "latest"
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Machine Extension - Azure Monitor Agent
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_machine_extension" "ubuntu_azure_monitor" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_virtual_machine.ubuntu.id
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
  virtual_machine_id         = azurerm_virtual_machine.ubuntu.id
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
