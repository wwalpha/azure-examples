# ----------------------------------------------------------------------------------------------
# Azure Private DNS Zone - Azure Monitor
# ----------------------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "monitor" {
  name                = "privatelink.monitor.azure.com"
  resource_group_name = var.resource_group_name
}

# ----------------------------------------------------------------------------------------------
# Azure Private DNS Zone Virtual Network Link - Azure Monitor
# ----------------------------------------------------------------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "monitor" {
  name                  = "monitor"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.monitor.name
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = false
}

# ----------------------------------------------------------------------------------------------
# Azure Private DNS Zone - Operations Management Suite
# ----------------------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "oms" {
  name                = "privatelink.oms.opinsights.azure.com"
  resource_group_name = var.resource_group_name
}

# ----------------------------------------------------------------------------------------------
# Azure Private DNS Zone Virtual Network Link - Operations Management Suite
# ----------------------------------------------------------------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "oms" {
  name                  = "oms"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.oms.name
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = false
}

# ----------------------------------------------------------------------------------------------
# Azure Private DNS Zone - Operations Manager
# ----------------------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "ods" {
  name                = "privatelink.ods.opinsights.azure.com"
  resource_group_name = var.resource_group_name
}

# ----------------------------------------------------------------------------------------------
# Azure Private DNS Zone Virtual Network Link - Operations Manager
# ----------------------------------------------------------------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "ods" {
  name                  = "ods"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.ods.name
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = false
}

# ----------------------------------------------------------------------------------------------
# Azure Private DNS Zone - Azure Automation
# ----------------------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "agentsvc" {
  name                = "privatelink.agentsvc.azure-automation.net"
  resource_group_name = var.resource_group_name
}

# ----------------------------------------------------------------------------------------------
# Azure Private DNS Zone Virtual Network Link - Azure Automation
# ----------------------------------------------------------------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "agentsvc" {
  name                  = "agentsvc"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.agentsvc.name
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = false
}

# ----------------------------------------------------------------------------------------------
# Azure Private DNS Zone - Blob Storage
# ----------------------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
}

# ----------------------------------------------------------------------------------------------
# Azure Private DNS Zone Virtual Network Link - Blob Storage
# ----------------------------------------------------------------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = "blob"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = false
}
