# ----------------------------------------------------------------------------------------------
# Azure Private Endpoint - Monitoring
# ----------------------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "monitoring" {
  depends_on = [
    azurerm_monitor_private_link_scope.this,
    azurerm_private_dns_zone.monitor,
    azurerm_private_dns_zone.oms,
    azurerm_private_dns_zone.ods,
    azurerm_private_dns_zone.agentsvc,
    azurerm_private_dns_zone.blob
  ]

  name                = "monitoring-endpoint"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.this.id

  private_service_connection {
    name                           = "monitoring_endpoint"
    private_connection_resource_id = azurerm_monitor_private_link_scope.this.id
    is_manual_connection           = false
    subresource_names              = ["azuremonitor"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.monitor.id,
      azurerm_private_dns_zone.oms.id,
      azurerm_private_dns_zone.ods.id,
      azurerm_private_dns_zone.agentsvc.id,
      azurerm_private_dns_zone.blob.id
    ]
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Private Endpoint Connection - Monitoring
# ----------------------------------------------------------------------------------------------
data "azurerm_private_endpoint_connection" "monitoring" {
  name                = azurerm_private_endpoint.monitoring.name
  resource_group_name = var.resource_group_name
}
