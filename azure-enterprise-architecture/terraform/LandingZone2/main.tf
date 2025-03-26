# ----------------------------------------------------------------------------------------------
# Azure Resource Group - Landing Zone 2
# ----------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "this" {
  name     = "rg-landingzone2-${var.suffix}"
  location = var.resource_group_location
}
