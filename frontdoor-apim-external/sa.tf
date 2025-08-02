# ----------------------------------------------------------------------------------------------
# Azure Storage Account - Azure Functions require a storage account for operation
# ----------------------------------------------------------------------------------------------
resource "azurerm_storage_account" "function" {
  name                     = "st${var.environment}${local.resource_suffix}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  # Simplified network rules - allow access for Function App creation
  network_rules {
    default_action = "Allow"
    bypass         = ["AzureServices"]
    # Will be tightened after deployment if needed
  }

  tags = local.common_tags
}

# Role assignment for Function App to access Storage Account
resource "azurerm_role_assignment" "function_storage_blob_data_owner" {
  scope                = azurerm_storage_account.function.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_linux_function_app.main.identity[0].principal_id

  depends_on = [
    azurerm_linux_function_app.main
  ]
}

# Role assignment for Function App to access Storage Account (Data Contributor)
resource "azurerm_role_assignment" "function_storage_account_contributor" {
  scope                = azurerm_storage_account.function.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = azurerm_linux_function_app.main.identity[0].principal_id

  depends_on = [
    azurerm_linux_function_app.main
  ]
}
