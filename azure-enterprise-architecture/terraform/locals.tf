locals {
  suffix    = random_id.this.hex
  tenant_id = data.azurerm_client_config.this.tenant_id
}

resource "random_id" "this" {
  byte_length = 4
}

data "azurerm_client_config" "this" {}
