locals {
  suffix    = random_id.this.hex
  tenant_id = data.azurerm_client_config.this.tenant_id

  frontend_port_name             = "FrontendPort"
  frontend_ip_configuration_name = "AGIPConfig"
  backend_address_pool_name      = "BackendAddressPool"
  backend_http_setting_name      = "BackendHttpSetting"
  http_listener_name             = "HttpListener"
  request_routing_rule_name      = "RequestRoutingRule"

  vm_user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y nginx
    sudo systemctl start nginx
    sudo systemctl status nginx
    sudo systemctl enable nginx
EOF
}

resource "random_id" "this" {
  byte_length = 4
}

resource "random_password" "password" {
  length  = 16
  special = true
  lower   = true
  upper   = true
  numeric = true
}

data "azurerm_client_config" "this" {}
