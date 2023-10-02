# ----------------------------------------------------------------------------------------------
# Azure Storage Account
# ----------------------------------------------------------------------------------------------
resource "azurerm_storage_account" "this" {
  name                          = "storage${var.suffix}"
  resource_group_name           = var.resource_group_name
  location                      = var.resource_group_location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  min_tls_version               = "TLS1_2"
  public_network_access_enabled = true
  enable_https_traffic_only     = true
}

# ----------------------------------------------------------------------------------------------
# Azure Storage Share
# ----------------------------------------------------------------------------------------------
resource "azurerm_storage_share" "public" {
  name                 = "public"
  storage_account_name = azurerm_storage_account.this.name
  access_tier          = "TransactionOptimized"
  quota                = 512
  acl {
    id = "GhostedRecall"
    access_policy {
      permissions = "r"
    }
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Storage Share
# ----------------------------------------------------------------------------------------------
resource "azurerm_storage_share" "private" {
  name                 = "private"
  storage_account_name = azurerm_storage_account.this.name
  access_tier          = "TransactionOptimized"
  quota                = 512
  acl {
    id = "GhostedRecall"
    access_policy {
      permissions = "r"
    }
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Storage Container
# ----------------------------------------------------------------------------------------------
resource "azurerm_storage_container" "this" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

# ----------------------------------------------------------------------------------------------
# Azure Role Assignment
# ----------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "this" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Reader and Data Access"
  principal_id         = "aebe95d6-843e-4ca9-8dd5-f59e313426ec"
}
