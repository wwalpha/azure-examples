# ----------------------------------------------------------------------------------------------
# Azure Log Analytics Workspace
# ----------------------------------------------------------------------------------------------
resource "azurerm_log_analytics_workspace" "this" {
  name                       = "workspace-${var.suffix}"
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name
  retention_in_days          = 730
  internet_ingestion_enabled = false
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Private Link Scoped Service - Workspace
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_private_link_scoped_service" "workspace" {
  name                = "amplsservice-workspace-${var.suffix}"
  resource_group_name = var.resource_group_name
  scope_name          = var.ampls_scope_name
  linked_resource_id  = azurerm_log_analytics_workspace.this.id
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Private Link Scoped Service - Data Collection Endpoint for Windows
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_private_link_scoped_service" "dce_windows" {
  name                = "amplsservice-dce-windows-${var.suffix}"
  resource_group_name = var.resource_group_name
  scope_name          = var.ampls_scope_name
  linked_resource_id  = azurerm_monitor_data_collection_endpoint.windows.id
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Private Link Scoped Service - Data Collection Endpoint for Linux
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_private_link_scoped_service" "dce_linux" {
  name                = "amplsservice-dce-linux-${var.suffix}"
  resource_group_name = var.resource_group_name
  scope_name          = var.ampls_scope_name
  linked_resource_id  = azurerm_monitor_data_collection_endpoint.linux.id
}
