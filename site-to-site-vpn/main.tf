terraform {
  backend "local" {
    path = "./tfstate/terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">3.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.0.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  use_msi = true
}

provider "azuread" {
  use_msi = true
}

# ----------------------------------------------------------------------------------------------
# Resource Group
# ----------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "this" {
  depends_on = [random_id.this]
  name       = "${var.resource_group_name}-${local.suffix}"
  location   = var.resource_group_location
}
