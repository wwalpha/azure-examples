# ----------------------------------------------------------------------------------------------
# Azure Storage Account - Logs
# ----------------------------------------------------------------------------------------------
resource "azurerm_storage_account" "logs" {
  name                     = "sa-logs-${var.suffix}"
  location                 = azurerm_resource_group.this.location
  resource_group_name      = azurerm_resource_group.this.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# ----------------------------------------------------------------------------------------------
# Azure Storage Account - Logs
# ----------------------------------------------------------------------------------------------
resource "azurerm_log_analytics_workspace" "this" {
  name                = "workspace-${var.suffix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.resource_group_location
  sku                 = "PerGB2018"
}
