# ----------------------------------------------------------------------------------------------
# Monitor Diagnostic Setting
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "this" {
  name                           = "SendToEventHub"
  target_resource_id             = "${var.storage_account_id}/fileServices/default/"
  eventhub_authorization_rule_id = data.azurerm_eventhub_namespace_authorization_rule.this.id

  enabled_log {
    category = "StorageWrite"

    retention_policy {
      enabled = false
    }
  }

  enabled_log {
    category = "StorageDelete"

    retention_policy {
      enabled = false
    }
  }
}

