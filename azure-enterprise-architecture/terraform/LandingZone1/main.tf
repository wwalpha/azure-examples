# ----------------------------------------------------------------------------------------------
# Azure Resource Group - Landing Zone 1
# ----------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "this" {
  name     = "rg-landingzone1-${var.suffix}"
  location = var.resource_group_location
}
