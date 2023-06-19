output "vnet" {
  value = azurerm_virtual_network.this
}

output "source_subnet_id" {
  value = azurerm_subnet.source.id
}

output "target_subnet_id" {
  value = azurerm_subnet.target.id
}
