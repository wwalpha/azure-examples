# ----------------------------------------------------------------------------------------------
# Azure Virtual Network
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network" "this" {
  name                = "vnet-spoke1-${var.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.vnet_address]
}

# ----------------------------------------------------------------------------------------------
# Azure Subnet
# ----------------------------------------------------------------------------------------------
resource "azurerm_subnet" "this" {
  count                = length(var.subnet_address)
  name                 = "subnet${count.index}-${var.suffix}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_address[count.index]]
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Hub Connection
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_hub_connection" "this" {
  name                      = "landingzone1-to-hub"
  virtual_hub_id            = var.virtual_hub_id
  remote_virtual_network_id = azurerm_virtual_network.this.id
  internet_security_enabled = true

  routing {
    associated_route_table_id = azurerm_virtual_hub_route_table.this.id

    propagated_route_table {
      route_table_ids = [azurerm_virtual_hub_route_table.this.id]
      labels          = ["VNet"]
    }
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Hub Route Table
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_hub_route_table" "this" {
  name           = "vhubrt1-${var.suffix}"
  virtual_hub_id = var.virtual_hub_id
  labels         = ["VNet"]

  route {
    name              = "VNetToVNet"
    destinations_type = "CIDR"
    destinations      = ["10.10.0.0/16"]
    next_hop_type     = "ResourceId"
    next_hop          = var.firewall_id
  }

  route {
    name              = "InternetToFirewall"
    destinations_type = "CIDR"
    destinations      = ["0.0.0.0/0"]
    next_hop_type     = "ResourceId"
    next_hop          = var.firewall_id
  }
}
