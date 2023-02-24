locals {
  suffix = random_id.this.hex
}

resource "random_id" "this" {
  byte_length = 4
}

data "azurerm_client_config" "this" {}

data "azurerm_subscription" "this" {}
