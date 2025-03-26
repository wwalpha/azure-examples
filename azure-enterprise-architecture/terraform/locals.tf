locals {
  suffix    = random_id.this.hex
  tenant_id = data.azurerm_client_config.this.tenant_id


}

resource "random_id" "this" {
  byte_length = 4
}

resource "random_password" "password" {
  length  = 16
  special = true
  lower   = true
  upper   = true
  numeric = true
}

data "azurerm_client_config" "this" {}

