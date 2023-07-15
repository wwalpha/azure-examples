output "storage_account_id" {
  value = azurerm_storage_account.this.id
}

output "storage_account_name" {
  value = azurerm_storage_account.this.name
}

output "storage_share_id" {
  value = azurerm_storage_share.this.resource_manager_id
}

output "storage_share_name" {
  value = azurerm_storage_share.this.name
}

output "storage_sync_id" {
  value = azurerm_storage_sync.this.id
}

output "sa_container_name" {
  value = azurerm_storage_container.this.name
}


