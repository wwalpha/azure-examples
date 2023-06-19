# ----------------------------------------------------------------------------------------------
# Azure Private DNS Zone - Azure File
# ----------------------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "file" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = var.resource_group_name
}
