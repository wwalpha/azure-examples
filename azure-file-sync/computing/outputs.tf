# ----------------------------------------------------------------------------------------------
# Public Server Ip Address
# ----------------------------------------------------------------------------------------------
output "public_vm_ip_address" {
  value = azurerm_network_interface.public.private_ip_address
}

# ----------------------------------------------------------------------------------------------
# Private Server Ip Address
# ----------------------------------------------------------------------------------------------
output "private_vm_ip_address" {
  value = azurerm_network_interface.public.private_ip_address
}
