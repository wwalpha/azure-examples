output "app_private_ip_address" {
  value = azurerm_network_interface.app.private_ip_address
}

output "database_private_ip_address" {
  value = azurerm_network_interface.database.private_ip_address
}
