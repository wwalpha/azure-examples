# ----------------------------------------------------------------------------------------------
# Azure Virtual WAN
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_wan" "this" {
  name                           = "vwan-${var.suffix}"
  location                       = azurerm_resource_group.this.location
  resource_group_name            = azurerm_resource_group.this.name
  allow_branch_to_branch_traffic = true
  disable_vpn_encryption         = false
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Hub
# ----------------------------------------------------------------------------------------------
resource "azurerm_virtual_hub" "this" {
  name                = "vhub-${var.suffix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  virtual_wan_id      = azurerm_virtual_wan.this.id
  sku                 = "Standard"
  address_prefix      = var.vhub_address_prefix
}

# ----------------------------------------------------------------------------------------------
# Azure Virtual Hub Connection
# ----------------------------------------------------------------------------------------------
# resource "azurerm_virtual_hub_connection" "this" {
#   name                      = "hub-connection-${var.suffix}"
#   virtual_hub_id            = azurerm_virtual_hub.this.id
#   remote_virtual_network_id = azurerm_virtual_network.spoke.id
#   internet_security_enabled = true
# }
