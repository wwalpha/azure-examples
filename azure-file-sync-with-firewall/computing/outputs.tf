# ----------------------------------------------------------------------------------------------
# Private Server Ip Address
# ----------------------------------------------------------------------------------------------
output "private_vm_ip_address" {
  value = azurerm_network_interface.private.private_ip_address
}
