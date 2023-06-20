# ----------------------------------------------------------------------------------------------
# Azure Private DNS Zone - Azure File
# ----------------------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "file" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = var.resource_group_name
}

# ----------------------------------------------------------------------------------------------
# Azure Private DNS Zone Virtual Network Link - Azure File
# ----------------------------------------------------------------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "file" {
  name                  = "file"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.file.name
  virtual_network_id    = azurerm_virtual_network.private.id
  registration_enabled  = false
}

# ----------------------------------------------------------------------------------------------
# Azure Private DNS Zone - Azure File Sync
# ----------------------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "afs" {
  name                = "privatelink.afs.azure.net"
  resource_group_name = var.resource_group_name
}

# ----------------------------------------------------------------------------------------------
# Azure Private DNS Zone Virtual Network Link - Azure File Sync
# ----------------------------------------------------------------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "afs" {
  name                  = "afs"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.afs.name
  virtual_network_id    = azurerm_virtual_network.private.id
  registration_enabled  = false
}

