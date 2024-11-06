terraform {
  backend "remote" {
    organization = "wwalpha"

    workspaces {
      name = "azure-virtual-hub-with-firewall"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">3.0.0"
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

locals {
  suffix = random_id.this.hex
}

resource "random_id" "this" {
  byte_length = 4
}

resource "azurerm_resource_group" "this" {
  name     = "vHub-with-firewall-${random_id.this.hex}"
  location = "Japan East"
}

module "networking" {
  source = "./networking"

  resource_group_name     = azurerm_resource_group.this.name
  resource_group_location = azurerm_resource_group.this.location
  suffix                  = local.suffix
}

module "computing" {
  source = "./computing"

  resource_group_name     = azurerm_resource_group.this.name
  resource_group_location = azurerm_resource_group.this.location
  app_subnet_id           = module.networking.app_subnet_id
  database_subnet_id      = module.networking.database_subnet_id
  azurevm_admin_username  = var.azurevm_admin_username
  azurevm_admin_password  = var.azurevm_admin_password
  suffix                  = local.suffix
}


# module "database" {
#   source = "./database"

#   resource_group_name     = azurerm_resource_group.this.name
#   resource_group_location = azurerm_resource_group.this.location
#   mssql_admin_username    = var.mssql_admin_username
#   mssql_admin_password    = var.mssql_admin_password
#   vnet_id                 = module.networking.vnet_id
#   vnet_subnets            = module.networking.vnet_subnets
#   suffix                  = local.suffix
# }

# module "storage" {
#   source = "./storage"

#   resource_group_name     = azurerm_resource_group.this.name
#   resource_group_location = azurerm_resource_group.this.location
#   vnet_id                 = module.networking.vnet_id
#   vnet_subnets            = module.networking.vnet_subnets
#   suffix                  = local.suffix
# }

# module "datafactory" {
#   depends_on = [
#     module.storage.storage_account_name,
#     module.database.mssql_connection_string
#   ]

#   source                           = "./datafactory"
#   resource_group_name              = azurerm_resource_group.this.name
#   resource_group_location          = azurerm_resource_group.this.location
#   vnet_id                          = module.networking.vnet_id
#   vnet_subnets                     = module.networking.vnet_subnets
#   storage_account_name             = module.storage.storage_account_name
#   mssql_connection_string          = module.database.mssql_connection_string
#   onpremise_connection_string      = local.onpremise_connection_string
#   is_self_hosted_ir_setup_finished = var.is_self_hosted_ir_setup_finished
#   suffix                           = local.suffix
# }

