output "agent_vnet" {
  value = azurerm_virtual_network.agent
}

output "source_subnet_id" {
  value = azurerm_subnet.agent.id
}

output "target_subnet_id" {
  value = azurerm_subnet.target.id
}
