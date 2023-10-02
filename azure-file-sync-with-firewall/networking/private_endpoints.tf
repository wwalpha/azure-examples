# ----------------------------------------------------------------------------------------------
# Azure Private Endpoint - Storage
# ----------------------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "storage" {
  depends_on = [
    azurerm_private_dns_zone.file,
  ]

  name                          = "storage-endpoint"
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  subnet_id                     = azurerm_subnet.private.id
  custom_network_interface_name = "storage-endpoint-nic"

  private_service_connection {
    name                           = "storage-endpoint"
    private_connection_resource_id = var.storage_account_id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.file.id
    ]
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Private Endpoint Connection - Storage
# ----------------------------------------------------------------------------------------------
data "azurerm_private_endpoint_connection" "storage" {
  name                = azurerm_private_endpoint.storage.name
  resource_group_name = var.resource_group_name
}

# ----------------------------------------------------------------------------------------------
# Azure Private Endpoint - Storage Sync
# ----------------------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "storagesync" {
  depends_on = [
    azurerm_private_dns_zone.file,
  ]

  name                          = "storagesync-endpoint"
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  subnet_id                     = azurerm_subnet.private.id
  custom_network_interface_name = "storagesync-endpoint-nic"

  private_service_connection {
    name                           = "storagesync-endpoint"
    private_connection_resource_id = var.storage_sync_id_private
    is_manual_connection           = false
    subresource_names              = ["Afs"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.afs.id
    ]
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Private Endpoint Connection - Storage Sync
# ----------------------------------------------------------------------------------------------
data "azurerm_private_endpoint_connection" "storagesync" {
  name                = azurerm_private_endpoint.storagesync.name
  resource_group_name = var.resource_group_name
}
