resource "azurerm_storage_sync" "this" {
  name                = "fileSync-${var.suffix}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
}

resource "azurerm_storage_sync_group" "this" {
  name            = "group${var.suffix}"
  storage_sync_id = azurerm_storage_sync.this.id
}

resource "azurerm_storage_sync_cloud_endpoint" "this" {
  name                      = "filesync-ce-${var.suffix}"
  storage_sync_group_id     = azurerm_storage_sync_group.this.id
  file_share_name           = azurerm_storage_share.this.name
  storage_account_id        = azurerm_storage_account.this.id
  storage_account_tenant_id = var.tenant_id
}
