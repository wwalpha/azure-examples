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

module "Connectivity" {
  source = "./Connectivity"

  suffix                  = local.suffix
  vhub_address_prefix     = "10.20.0.0/23"
  vnet_address            = "10.10.0.0/16"
  subnet_address_firewall = "10.10.1.0/24"
  subnet_address_gateway  = "10.10.2.0/24"
}

module "LandingZone1" {
  source = "./LandingZone1"

  suffix         = local.suffix
  vnet_address   = "10.10.1.0/24"
  subnet_address = ["10.10.1.0/25", "10.10.1.128/25"]
}

module "LandingZone2" {
  source = "./LandingZone2"

  suffix         = local.suffix
  vnet_address   = "10.10.2.0/24"
  subnet_address = ["10.10.2.0/25", "10.10.2.128/25"]
}
