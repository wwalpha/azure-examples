# ----------------------------------------------------------------------------------------------
# Azure Monitor Log Profile
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_log_profile" "this" {
  name                  = "log-profile-${var.suffix}"
  location              = azurerm_resource_group.this.location
  resource_group_name   = azurerm_resource_group.this.name
  retention_policy_days = 30
  categories            = ["Write", "Delete", "Action"]
  enabled               = true
  storage_account_id    = azurerm_storage_account.logs.id
}
