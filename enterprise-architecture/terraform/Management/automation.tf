# ----------------------------------------------------------------------------------------------
# Azure Automation Account
# ----------------------------------------------------------------------------------------------
resource "azurerm_automation_account" "this" {
  name                = "automation-${var.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "Basic"
}
