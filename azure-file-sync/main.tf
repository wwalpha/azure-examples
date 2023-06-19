terraform {
  backend "local" {
    path = "./tfstate/terraform.tfstate"
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

  tenant_id               = local.tenant_id
  resource_group_name     = azurerm_resource_group.this.name
  resource_group_location = azurerm_resource_group.this.location
  suffix                  = local.suffix
  storage_account_id      = module.storage.storage_account_id
  storage_sync_id         = module.storage.storage_sync_id
}

module "computing" {
  source = "./computing"

  resource_group_name     = azurerm_resource_group.this.name
  resource_group_location = azurerm_resource_group.this.location
  azurevm_admin_username  = var.azurevm_admin_username
  azurevm_admin_password  = var.azurevm_admin_password
  source_subnet_id        = module.networking.source_subnet_id
  target_subnet_id        = module.networking.target_subnet_id
  identity_id             = module.security.container_instance_contributor_role_id
  suffix                  = local.suffix
}

# resource "azurerm_private_endpoint" "this" {
#   name                          = "storagesync-endpoint"
#   location                      = azurerm_resource_group.this.location
#   resource_group_name           = azurerm_resource_group.this.name
#   subnet_id                     = "/subscriptions/cda6bd1c-c03b-40b5-a211-9b0bd4583a14/resourceGroups/file-sync-70002a3a/providers/Microsoft.Network/virtualNetworks/agent-vnet-70002a3a/subnets/TargetSubnet-70002a3a"
#   custom_network_interface_name = "storagesync-endpoint-nic"

#   private_service_connection {
#     private_connection_resource_id = "/subscriptions/cda6bd1c-c03b-40b5-a211-9b0bd4583a14/resourceGroups/file-sync-70002a3a/providers/Microsoft.Storage/storageAccounts/storage70002a3a"
#     is_manual_connection           = false
#     subresource_names              = ["file"]
#     name                           = "storagesync-endpoint"
#   }

#   private_dns_zone_group {
#     name                 = "default"
#     private_dns_zone_ids = ["/subscriptions/cda6bd1c-c03b-40b5-a211-9b0bd4583a14/resourceGroups/file-sync-70002a3a/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"]
#   }
# }
