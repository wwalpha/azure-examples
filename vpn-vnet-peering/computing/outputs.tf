# ----------------------------------------------------------------------------------------------
# VM1 Ip Address
# ----------------------------------------------------------------------------------------------
output "vm1_private_ip_address" {
  value = azurerm_network_interface.vm1.private_ip_address
}

# ----------------------------------------------------------------------------------------------
# VM2 Ip Address
# ----------------------------------------------------------------------------------------------
output "vm2_private_ip_address" {
  value = azurerm_network_interface.vm2.private_ip_address
}