# ----------------------------------------------------------------------------------------------
# Azure Firewall Policy
# ----------------------------------------------------------------------------------------------
resource "azurerm_firewall_policy" "this" {
  name                = "allow-internet"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Standard"
}

# ----------------------------------------------------------------------------------------------
# Azure Firewall
# ----------------------------------------------------------------------------------------------
resource "azurerm_firewall" "this" {
  depends_on          = [azurerm_virtual_hub.this]
  name                = "fw-central-${var.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "AZFW_Hub"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.this.id

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.this.id
    public_ip_count = 2
  }
}

# ----------------------------------------------------------------------------------------------
# Azure Public IP - Firewall
# ----------------------------------------------------------------------------------------------
# resource "azurerm_public_ip" "firewall_pip" {
#   name                = "firewall-pip-${var.suffix}"
#   location            = azurerm_resource_group.this.location
#   resource_group_name = azurerm_resource_group.this.name
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }
