# ----------------------------------------------------------------------------------------------
# Azure Log Analytics Workspace ID
# ----------------------------------------------------------------------------------------------
output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.this.id
}

# ----------------------------------------------------------------------------------------------
# Azure Log Analytics Workspace Name
# ----------------------------------------------------------------------------------------------
output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.this.name
}
