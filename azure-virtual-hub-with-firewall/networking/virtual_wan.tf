resource "azurerm_virtual_wan" "this" {
  name                = "vwan-${var.suffix}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_hub" "this" {
  name                = "vhub-${var.suffix}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  virtual_wan_id      = azurerm_virtual_wan.this.id
  address_prefix      = "10.20.0.0/16"
}

resource "azurerm_virtual_hub_connection" "app_vnet" {
  name                      = "app_vnet"
  virtual_hub_id            = azurerm_virtual_hub.this.id
  remote_virtual_network_id = azurerm_virtual_network.app.id
  internet_security_enabled = true
}

# resource "azurerm_virtual_hub_route_table_route" "app_vnet" {
#   route_table_id = azurerm_virtual_hub.this.default_route_table_id

#   name              = "app-rt"
#   destinations_type = "CIDR"
#   destinations      = ["10.0.0.0/16"]
#   next_hop_type     = "ResourceId"
#   next_hop          = azurerm_virtual_hub_connection.app_vnet.id
# }

resource "azurerm_virtual_hub_connection" "database_vnet" {
  name                      = "database_vnet"
  virtual_hub_id            = azurerm_virtual_hub.this.id
  remote_virtual_network_id = azurerm_virtual_network.database.id
  internet_security_enabled = true
}

# resource "azurerm_virtual_hub_route_table_route" "database_vnet" {
#   route_table_id = azurerm_virtual_hub.this.default_route_table_id

#   name              = "database-rt"
#   destinations_type = "CIDR"
#   destinations      = ["10.0.0.0/16"]
#   next_hop_type     = "ResourceId"
#   next_hop          = azurerm_virtual_hub_connection.database_vnet.id
# }
