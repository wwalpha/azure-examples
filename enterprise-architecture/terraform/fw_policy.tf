# ----------------------------------------------------------------------------------------------
# Azure Firewall Policy Rule Collection Group - NAT
# ----------------------------------------------------------------------------------------------
resource "azurerm_firewall_policy_rule_collection_group" "nat" {
  name               = "DefaultDnatRuleCollectionGroup"
  firewall_policy_id = module.Connectivity.firewall_policy_id
  priority           = 1000

  nat_rule_collection {
    name     = "AllowSSHFromInternet"
    action   = "Dnat"
    priority = 100

    rule {
      name                = "AllowSSHFromInternetForServer01"
      protocols           = ["TCP"]
      source_addresses    = ["*"]
      destination_address = module.Connectivity.vhub_public_ip_addresses[0]
      destination_ports   = ["22"]
      translated_address  = module.LandingZone1.azurevm_private_ip_address
      translated_port     = 22
    }

    rule {
      name                = "AllowSSHFromInternetForServer02"
      protocols           = ["TCP"]
      source_addresses    = ["*"]
      destination_address = module.Connectivity.vhub_public_ip_addresses[1]
      destination_ports   = ["22"]
      translated_address  = module.LandingZone2.azurevm_private_ip_address
      translated_port     = 22
    }
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Firewall Policy Rule Collection Group - Network
# ----------------------------------------------------------------------------------------------
resource "azurerm_firewall_policy_rule_collection_group" "network" {
  name               = "DefaultNetworkRuleCollectionGroup"
  firewall_policy_id = module.Connectivity.firewall_policy_id
  priority           = 2000

  network_rule_collection {
    name     = "AllowRules"
    priority = 2000
    action   = "Allow"

    rule {
      name                  = "AllowDNS"
      protocols             = ["UDP"]
      source_addresses      = ["*"]
      destination_addresses = ["209.244.0.3"]
      destination_ports     = ["53"]
    }
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Firewall Policy Rule Collection Group - Application
# ----------------------------------------------------------------------------------------------
resource "azurerm_firewall_policy_rule_collection_group" "application" {
  name               = "DefaultApplicationRuleCollectionGroup"
  firewall_policy_id = module.Connectivity.firewall_policy_id
  priority           = 3000

  application_rule_collection {
    name     = "DenyRules"
    priority = 1000
    action   = "Deny"

    rule {
      name = "deny_microsoft"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["10.10.0.0/16"]
      destination_fqdns = ["*.microsoft.com"]
    }
  }

  application_rule_collection {
    name     = "AllowRules"
    priority = 2000
    action   = "Allow"

    rule {
      name = "allow_google"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["10.10.0.0/16"]
      destination_fqdns = ["www.google.com"]
    }
  }
}

