resource "azurerm_automation_account" "this" {
  name                = "automation-${var.suffix}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku_name            = "Basic"
}

resource "azurerm_automation_runbook" "this" {
  name                    = "SyncAzureFilesToBlobStorage"
  location                = var.resource_group_location
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  log_verbose             = "true"
  log_progress            = "true"
  runbook_type            = "PowerShell"

  publish_content_link {
    uri = "https://raw.githubusercontent.com/wwalpha/azure-examples/master/azure-file-sync/runbook/SyncAzureFileToBlobStorage.ps1"
  }
}

resource "azurerm_automation_schedule" "this" {
  name                    = "Every1Hour"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  frequency               = "Hour"
  interval                = 1
  timezone                = "Asia/Tokyo"
  start_time              = "2025-01-01T12:00:00+09:00"
}
