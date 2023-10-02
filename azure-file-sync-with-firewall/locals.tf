locals {
  suffix          = random_id.this.hex
  tenant_id       = data.azurerm_client_config.this.tenant_id
  subscription_id = data.azurerm_subscription.primary.id
}

resource "random_id" "this" {
  byte_length = 4
}

data "azurerm_client_config" "this" {}

data "azurerm_subscription" "primary" {}
