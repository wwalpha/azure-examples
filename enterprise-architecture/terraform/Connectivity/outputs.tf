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
# Azure Firewall ID
# ----------------------------------------------------------------------------------------------
output "firewall_id" {
  value = azurerm_firewall.this.id
}

# ----------------------------------------------------------------------------------------------
# Azure Firewall Name
# ----------------------------------------------------------------------------------------------
output "firewall_name" {
  value = azurerm_firewall.this.name
}

# ----------------------------------------------------------------------------------------------
# Azure Firewall Policy Name
# ----------------------------------------------------------------------------------------------
output "firewall_policy_id" {
  value = azurerm_firewall_policy.this.id
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
