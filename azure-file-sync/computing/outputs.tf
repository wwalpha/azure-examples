# ----------------------------------------------------------------------------------------------
# Source Server Private Ip Address
# ----------------------------------------------------------------------------------------------
output "source_private_ip_address" {
  value = azurerm_network_interface.source.private_ip_address
}

# ----------------------------------------------------------------------------------------------
# Target Server Private Ip Address
# ----------------------------------------------------------------------------------------------
output "target_private_ip_address" {
  value = azurerm_network_interface.target.private_ip_address
}
