# ----------------------------------------------------------------------------------------------
# VNet Subnet ID
# ----------------------------------------------------------------------------------------------
output "vm_subnet_id" {
  value = azurerm_subnet.this.id
}

# ----------------------------------------------------------------------------------------------
# Azure Monitor Private Link Scope Name
# ----------------------------------------------------------------------------------------------
output "ampls_scope_name" {
  value = azurerm_monitor_private_link_scope.this.name
}