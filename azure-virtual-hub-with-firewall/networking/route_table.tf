resource "azurerm_route_table" "app" {
  depends_on                    = [azurerm_subnet.app]
  name                          = "app-subnet-rt-${var.suffix}"
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = false

  route {
    name                   = "internet"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.this.virtual_hub[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "app" {
  subnet_id      = azurerm_subnet.app.id
  route_table_id = azurerm_route_table.app.id
}


resource "azurerm_route_table" "database" {
  depends_on                    = [azurerm_subnet.database]
  name                          = "database-subnet-rt-${var.suffix}"
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = false

  route {
    name                   = "internet"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.this.virtual_hub[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "database" {
  subnet_id      = azurerm_subnet.database.id
  route_table_id = azurerm_route_table.database.id
}
