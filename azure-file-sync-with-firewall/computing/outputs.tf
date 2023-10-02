# ----------------------------------------------------------------------------------------------
# Public Server Ip Address
# ----------------------------------------------------------------------------------------------
output "public_vm_ip_address" {
  value = azurerm_network_interface.public_active.private_ip_address
}

output "public_standby_vm_ip_address" {
  value = azurerm_network_interface.public_standby.private_ip_address
}

# ----------------------------------------------------------------------------------------------
# Private Server Ip Address
# ----------------------------------------------------------------------------------------------
output "private_vm_ip_address" {
  value = azurerm_network_interface.private.private_ip_address
}
