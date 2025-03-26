# ----------------------------------------------------------------------------------------------
# Azure Resource Group - Management
# ----------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "this" {
  name     = "rg-management-${var.suffix}"
  location = var.resource_group_location
}
