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
  virtual_hub_id = module.Connectivity.virtual_hub_id
  vnet_address   = "10.10.1.0/24"
  subnet_address = ["10.10.1.0/25", "10.10.1.128/25"]
  vm_password    = local.vm_password
}

module "LandingZone2" {
  source = "./LandingZone2"

  suffix         = local.suffix
  virtual_hub_id = module.Connectivity.virtual_hub_id
  vnet_address   = "10.10.2.0/24"
  subnet_address = ["10.10.2.0/25", "10.10.2.128/25"]
  vm_password    = local.vm_password
}

# resource "null_resource" "dnat" {
#   provisioner "local-exec" {
#     command = "sh ${path.module}/scripts/createNatRule.sh"

#     environment = {
#       COLLECTION_NAME    = module.Connectivity.firewall_policy_rule_collection_group_name_nat
#       FIREWALL_NAME      = module.Connectivity.firewall_name
#       RESOURCE_GROUP     = module.Connectivity.resource_group_name
#       NAME               = "AllowRDPFromInternet"
#       ACTION             = "Dnat"
#       PRIORITY           = "100"
#       PROTOCOLS          = "TCP"
#       SOURCE_ADDRESSES   = "*"
#       DEST_ADDR          = "*"
#       DESTINATION_PORTS  = "3389"
#       TRANSLATED_ADDRESS = module.LandingZone1.subnet_address[0]
#       TRANSLATED_PORT    = "3389"
#     }
#   }

#   provisioner "local-exec" {
#     when    = destroy
#     command = "sh ${path.module}/scripts/deleteProfile.sh"
#   }
# }
