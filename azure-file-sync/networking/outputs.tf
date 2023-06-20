output "public_vnet" {
  value = azurerm_virtual_network.public.id
}

output "private_vnet" {
  value = azurerm_virtual_network.private.id
}

output "public_subnet_id" {
  value = azurerm_subnet.public.id
}

output "private_subnet_id" {
  value = azurerm_subnet.private.id
}
