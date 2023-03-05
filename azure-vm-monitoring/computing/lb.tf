# ----------------------------------------------------------------------------------------------
# Azure Public IP
# ----------------------------------------------------------------------------------------------
resource "azurerm_public_ip" "this" {
  name                = "gip-${var.suffix}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# ----------------------------------------------------------------------------------------------
# Azure Load Balancer 
# ----------------------------------------------------------------------------------------------
resource "azurerm_lb" "this" {
  depends_on = [
    azurerm_linux_virtual_machine.rhel_86,
    azurerm_linux_virtual_machine.ubuntu,
  ]
  name                = "lb-${var.suffix}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "frontendip"
    public_ip_address_id = azurerm_public_ip.this.id
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Load Balancer Rule - Ubuntu Http
# ----------------------------------------------------------------------------------------------
resource "azurerm_lb_probe" "ubuntu" {
  loadbalancer_id     = azurerm_lb.this.id
  name                = "http-probe"
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 5
}

# ----------------------------------------------------------------------------------------------
# Azure Load Balancer Rule - Ubuntu Http
# ----------------------------------------------------------------------------------------------
resource "azurerm_lb_rule" "ubuntu_http" {
  name                           = "Ubuntu_Http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  loadbalancer_id                = azurerm_lb.this.id
  probe_id                       = azurerm_lb_probe.ubuntu.id
  frontend_ip_configuration_name = azurerm_lb.this.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ubuntu.id]
  disable_outbound_snat          = true
}

# ----------------------------------------------------------------------------------------------
# Azure Load Balancer Rule - RHEL Http
# ----------------------------------------------------------------------------------------------
resource "azurerm_lb_rule" "rhel_http" {
  name                           = "RHEL_Http"
  protocol                       = "Tcp"
  frontend_port                  = 81
  backend_port                   = 80
  loadbalancer_id                = azurerm_lb.this.id
  probe_id                       = azurerm_lb_probe.ubuntu.id
  frontend_ip_configuration_name = azurerm_lb.this.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.rhel.id]
  disable_outbound_snat          = true
}

# ----------------------------------------------------------------------------------------------
# Azure Load Balancer Outbound Rule - Ubuntu
# ----------------------------------------------------------------------------------------------
resource "azurerm_lb_outbound_rule" "this" {
  name                     = "UbuntuAllowInternet"
  loadbalancer_id          = azurerm_lb.this.id
  protocol                 = "Tcp"
  backend_address_pool_id  = azurerm_lb_backend_address_pool.ubuntu.id
  allocated_outbound_ports = 1024

  frontend_ip_configuration {
    name = azurerm_lb.this.frontend_ip_configuration[0].name
  }
}
