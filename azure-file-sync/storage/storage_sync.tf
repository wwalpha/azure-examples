# ----------------------------------------------------------------------------------------------
# Azure Storage Sync - Public
# ----------------------------------------------------------------------------------------------
resource "azurerm_storage_sync" "this" {
  name                = "fileSync-public-${var.suffix}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
}

# ----------------------------------------------------------------------------------------------
# Azure Storage Sync Group - Public
# ----------------------------------------------------------------------------------------------
resource "azurerm_storage_sync_group" "this" {
  name            = "group${var.suffix}"
  storage_sync_id = azurerm_storage_sync.this.id
}

# ----------------------------------------------------------------------------------------------
# Azure Storage Sync Cloud Endpoint - Public
# ----------------------------------------------------------------------------------------------
resource "azurerm_storage_sync_cloud_endpoint" "this" {
  name                      = "filesync-ce-${var.suffix}"
  storage_sync_group_id     = azurerm_storage_sync_group.this.id
  file_share_name           = azurerm_storage_share.public.name
  storage_account_id        = azurerm_storage_account.this.id
  storage_account_tenant_id = var.tenant_id
}

# ----------------------------------------------------------------------------------------------
# Azure Storage Sync - Private
# ----------------------------------------------------------------------------------------------
resource "azurerm_storage_sync" "private" {
  name                    = "fileSync-private-${var.suffix}"
  resource_group_name     = var.resource_group_name
  location                = var.resource_group_location
  incoming_traffic_policy = "AllowVirtualNetworksOnly"
}

# ----------------------------------------------------------------------------------------------
# Azure Storage Sync Group - Private
# ----------------------------------------------------------------------------------------------
resource "azurerm_storage_sync_group" "private" {
  name            = "group${var.suffix}"
  storage_sync_id = azurerm_storage_sync.private.id
}

# ----------------------------------------------------------------------------------------------
# Azure Storage Sync Cloud Endpoint - Private
# ----------------------------------------------------------------------------------------------
resource "azurerm_storage_sync_cloud_endpoint" "private" {
  name                      = "filesync-ce-${var.suffix}"
  storage_sync_group_id     = azurerm_storage_sync_group.private.id
  file_share_name           = azurerm_storage_share.private.name
  storage_account_id        = azurerm_storage_account.this.id
  storage_account_tenant_id = var.tenant_id
}
