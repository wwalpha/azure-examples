output "vnet1_id" {
  value = azurerm_virtual_network.vnet1.id
}

output "vnet2_id" {
  value = azurerm_virtual_network.vnet2.id
}

output "vnet1_subnet_id" {
  value = azurerm_subnet.vnet1.id
}

output "vnet2_subnet_id" {
  value = azurerm_subnet.vnet2.id
}
