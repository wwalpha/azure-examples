output "app_vnet_id" {
  value = azurerm_virtual_network.app.id
}

output "app_subnet_id" {
  value = azurerm_subnet.app.id
}

output "database_vnet_id" {
  value = azurerm_virtual_network.database.id
}

output "database_subnet_id" {
  value = azurerm_subnet.database.id
}

output "firewall" {
  value = azurerm_firewall.this
}

output "app_vnet_address_space" {
  value = azurerm_virtual_network.app.address_space
}

output "database_vnet_address_space" {
  value = azurerm_virtual_network.database.address_space
}
