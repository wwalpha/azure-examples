# ----------------------------------------------------------------------------------------------
# Azure VM Admin Password
# ----------------------------------------------------------------------------------------------
output "vm_admin_password" {
  value     = random_password.password.result
  sensitive = true
}

# ----------------------------------------------------------------------------------------------
# Azure VM IP Address
# ----------------------------------------------------------------------------------------------
output "vm_ip_address" {
  value = azurerm_linux_virtual_machine.this[*].private_ip_address
}

# ----------------------------------------------------------------------------------------------
# Azure Application Gateway Frontend IP Address
# ----------------------------------------------------------------------------------------------
output "gateway_frontend_ip" {
  value = "http://${azurerm_public_ip.this.ip_address}"
}
