# ----------------------------------------------------------------------------------------------
# EventHub Namespace
# ----------------------------------------------------------------------------------------------
resource "azurerm_eventhub_namespace" "this" {
  name                = "eventhub-${var.suffix}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "Basic"
  capacity            = 1
}

# ----------------------------------------------------------------------------------------------
# EventHub Namespace Authorization Rule
# ----------------------------------------------------------------------------------------------
data "azurerm_eventhub_namespace_authorization_rule" "this" {
  name                = "RootManageSharedAccessKey"
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_eventhub_namespace.this.name
}

