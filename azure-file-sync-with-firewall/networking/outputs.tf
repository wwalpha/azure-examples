output "private_vnet" {
  value = azurerm_virtual_network.private.id
}

output "private_subnet_id" {
  value = azurerm_subnet.private.id
}
