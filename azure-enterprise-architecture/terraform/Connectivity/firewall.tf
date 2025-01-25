# ----------------------------------------------------------------------------------------------
# Azure Firewall Policy
# ----------------------------------------------------------------------------------------------
resource "azurerm_firewall_policy" "this" {
  name                = "allow-internet"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Standard"
}

# ----------------------------------------------------------------------------------------------
# Azure Firewall
# ----------------------------------------------------------------------------------------------
resource "azurerm_firewall" "this" {
  name                = "fw-central-${var.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "AZFW_Hub"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.this.id

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.this.id
    public_ip_count = 2
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "dnat" {
  name               = "DefaultDnatRuleCollectionGroup"
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = 1000
}

resource "azurerm_firewall_policy_rule_collection_group" "network" {
  name               = "DefaultNetworkRuleCollectionGroup"
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = 2000

  # network_rule_collection {
  #   name     = "DenyRules"
  #   priority = 1000
  #   action   = "Deny"
  # }

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

resource "azurerm_firewall_policy_rule_collection_group" "application" {
  name               = "DefaultApplicationRuleCollectionGroup"
  firewall_policy_id = azurerm_firewall_policy.this.id
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
      source_addresses  = azurerm_subnet.app.address_prefixes
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
      source_addresses  = azurerm_subnet.app.address_prefixes
      destination_fqdns = ["www.google.com"]
    }
  }
}

