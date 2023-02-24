# ----------------------------------------------------------------------------------------------
# Azure Log Analytics Workspace ID
# ----------------------------------------------------------------------------------------------
output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.this.id
}
