# ----------------------------------------------------------------------------------------------
# Azure Monitor Private Link Scope
# ----------------------------------------------------------------------------------------------
resource "azurerm_monitor_private_link_scope" "this" {
  name                = "ampls-${var.suffix}"
  resource_group_name = var.resource_group_name
}
