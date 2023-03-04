terraform {
  backend "remote" {
    organization = "wwalpha"

    workspaces {
      name = "azure-vm-monitoring"
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

# ----------------------------------------------------------------------------------------------
# Azure Resource Group
# ----------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "this" {
  depends_on = [random_id.this]
  name       = "${var.resource_group_name}-${local.suffix}"
  location   = var.resource_group_location
}

# ----------------------------------------------------------------------------------------------
# Azure Networking Module
# ----------------------------------------------------------------------------------------------
module "networking" {
  source = "./networking"

  resource_group_name     = azurerm_resource_group.this.name
  resource_group_location = azurerm_resource_group.this.location
  suffix                  = local.suffix
  my_ip_address           = var.my_ip_address
}

# ----------------------------------------------------------------------------------------------
# Azure Computing Module
# ----------------------------------------------------------------------------------------------
module "computing" {
  source = "./computing"

  resource_group_name     = azurerm_resource_group.this.name
  resource_group_location = azurerm_resource_group.this.location
  azurevm_admin_username  = var.azurevm_admin_username
  azurevm_admin_password  = var.azurevm_admin_password
  vnet_id                 = module.networking.vnet_id
  vnet_subnet_id          = module.networking.vnet_subnet_id
  suffix                  = local.suffix
}

# ----------------------------------------------------------------------------------------------
# Azure Monitoring Module
# ----------------------------------------------------------------------------------------------
module "monitoring" {
  source = "./monitoring"

  resource_group_name     = azurerm_resource_group.this.name
  resource_group_location = azurerm_resource_group.this.location
  suffix                  = local.suffix
  win2016_vm_id           = module.computing.win2016_vm_id
  win2022_vm_id           = module.computing.win2022_vm_id
  rhel_86_vm_id           = module.computing.rhel_86_vm_id
  ubuntu_2004_vm_id       = module.computing.ubuntu_2004_vm_id
  ampls_scope_name        = module.networking.ampls_scope_name
}
