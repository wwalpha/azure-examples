output "azure_vpn_gateway_public_ip" {
  value = azurerm_public_ip.vpngw.ip_address
}
