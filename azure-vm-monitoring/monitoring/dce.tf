# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Endpoint for Windows
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_data_collection_endpoint" "windows" {
  name                          = "mdce-windows-${var.suffix}"
  description                   = "monitor_data_collection_endpoint"
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  kind                          = "Windows"
  public_network_access_enabled = false
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Endpoint for Linux
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_data_collection_endpoint" "linux" {
  name                          = "mdce-linux-${var.suffix}"
  description                   = "monitor_data_collection_endpoint"
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  kind                          = "Linux"
  public_network_access_enabled = false
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Rule Association - Windows Server 2016
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_data_collection_rule_association" "dce_win2016" {
  target_resource_id          = var.win2016_vm_id
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.windows.id
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Rule Association - Windows Server 2022
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_data_collection_rule_association" "dce_win2022" {
  target_resource_id          = var.win2022_vm_id
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.windows.id
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Rule Association - Redhat Enterprise Linux 8.6
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_data_collection_rule_association" "dce_rhel_86" {
  target_resource_id          = var.rhel_86_vm_id
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.linux.id
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Data Collection Rule Association - Ubuntu 20.04
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_data_collection_rule_association" "dce_ubuntu_2004" {
  target_resource_id          = var.ubuntu_2004_vm_id
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.linux.id
}
