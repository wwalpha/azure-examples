# ----------------------------------------------------------------------------------------------
# Azure Resource Group - Connectivity
# ----------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "this" {
  name     = "rg-connectivity-${var.suffix}"
  location = var.resource_group_location
}
