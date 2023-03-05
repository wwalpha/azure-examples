# ----------------------------------------------------------------------------------------------
# Azure Load Balancer Backend Address Pool - Ubuntu
# ----------------------------------------------------------------------------------------------
resource "azurerm_lb_backend_address_pool" "ubuntu" {
  name            = "UbuntuPool"
  loadbalancer_id = azurerm_lb.this.id
}

# ----------------------------------------------------------------------------------------------
# Azure Load Balancer Backend Address Pool Association - Ubuntu
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface_backend_address_pool_association" "ubuntu" {
  network_interface_id    = azurerm_network_interface.ubuntu.id
  ip_configuration_name   = azurerm_network_interface.ubuntu.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.ubuntu.id
}

# ----------------------------------------------------------------------------------------------
# Azure Load Balancer Backend Address Pool - RHEL
# ----------------------------------------------------------------------------------------------
resource "azurerm_lb_backend_address_pool" "rhel" {
  name            = "RHELPool"
  loadbalancer_id = azurerm_lb.this.id
}

# ----------------------------------------------------------------------------------------------
# Azure Load Balancer Backend Address Pool Association - RHEL
# ----------------------------------------------------------------------------------------------
resource "azurerm_network_interface_backend_address_pool_association" "rhel" {
  network_interface_id    = azurerm_network_interface.rhel_86.id
  ip_configuration_name   = azurerm_network_interface.rhel_86.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.rhel.id
}
