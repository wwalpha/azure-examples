# ----------------------------------------------------------------------------------------------
# Azure Virtual Network
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_network" "this" {
  name                = "vnet-azfw-${var.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.vnet_address]
}

# ----------------------------------------------------------------------------------------------
# Azure Subnet - AzureFirewallSubnet
# ----------------------------------------------------------------------------------------------
resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_address_firewall]
}

# ----------------------------------------------------------------------------------------------
# Azure Subnet - AzureFirewallSubnet
# ----------------------------------------------------------------------------------------------
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_address_gateway]
}
