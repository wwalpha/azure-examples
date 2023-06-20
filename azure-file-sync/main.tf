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

resource "azurerm_resource_group" "this" {
  depends_on = [random_id.this]
  name       = "${var.resource_group_name}-${local.suffix}"
  location   = var.resource_group_location
}

module "storage" {
  source = "./storage"

  suffix                  = local.suffix
  tenant_id               = local.tenant_id
  resource_group_name     = azurerm_resource_group.this.name
  resource_group_location = azurerm_resource_group.this.location
}

module "security" {
  source = "./security"
}

module "networking" {
  depends_on = [module.storage]
  source     = "./networking"

  suffix                  = local.suffix
  tenant_id               = local.tenant_id
  resource_group_name     = azurerm_resource_group.this.name
  resource_group_location = azurerm_resource_group.this.location
  storage_account_id      = module.storage.storage_account_id
  storage_sync_id_private = module.storage.storage_sync_id_private
}

module "computing" {
  source = "./computing"

  suffix                  = local.suffix
  resource_group_name     = azurerm_resource_group.this.name
  resource_group_location = azurerm_resource_group.this.location
  azurevm_admin_username  = var.azurevm_admin_username
  azurevm_admin_password  = var.azurevm_admin_password
  public_subnet_id        = module.networking.public_subnet_id
  private_subnet_id       = module.networking.private_subnet_id
  identity_id             = module.security.container_instance_contributor_role_id
}
