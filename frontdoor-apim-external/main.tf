# Azure Front Door + APIM External + Azure Function (Private Endpoint) Configuration

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.37.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.0"
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

# Random suffix for unique naming
resource "random_id" "main" {
  byte_length = 4
}

locals {
  resource_suffix = random_id.main.hex
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}
