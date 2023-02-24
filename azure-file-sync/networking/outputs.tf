output "agent_vnet" {
  value = azurerm_virtual_network.agent
}

output "agent_subnet_id" {
  value = azurerm_subnet.agent.id
}
