# ----------------------------------------------------------------------------------------------
# Resource Group Name
# ----------------------------------------------------------------------------------------------
output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Hub Id
# ----------------------------------------------------------------------------------------------
output "virtual_hub_id" {
  value = azurerm_virtual_hub.this.id
}

# ----------------------------------------------------------------------------------------------
# Azure Firewall Name
# ----------------------------------------------------------------------------------------------
output "firewall_name" {
  value = azurerm_firewall.this.name
}

# ----------------------------------------------------------------------------------------------
# Firewall policy rule collection group name - DNAT
# ----------------------------------------------------------------------------------------------
output "firewall_policy_rule_collection_group_name_nat" {
  value = azurerm_firewall_policy_rule_collection_group.nat.name
}

# ----------------------------------------------------------------------------------------------
# Firewall policy rule collection group name - Network
# ----------------------------------------------------------------------------------------------
output "firewall_policy_rule_collection_group_name_network" {
  value = azurerm_firewall_policy_rule_collection_group.network.name
}

# ----------------------------------------------------------------------------------------------
# Firewall policy rule collection group name - Application
# ----------------------------------------------------------------------------------------------
output "firewall_policy_rule_collection_group_name_application" {
  value = azurerm_firewall_policy_rule_collection_group.network.name
}

# ----------------------------------------------------------------------------------------------
# Firewall policy rule collection group name - Application
# ----------------------------------------------------------------------------------------------
output "vhub_public_ip_addresses" {
  value = azurerm_firewall.this.virtual_hub[0].public_ip_addresses
}

output "test" {
  value = azurerm_firewall.this
}

output "test2" {
  value = azurerm_virtual_hub.this
}
