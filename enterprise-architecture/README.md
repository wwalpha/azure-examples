# [Azure Enterprise Scalable Architecture (Azure Landing Zone)](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/)


```shell
provider "azurerm" {
  features {}
}

# Hub Resource Group
resource "azurerm_resource_group" "hub" {
  name     = "hub-rg"
  location = "East US"
}

# Virtual Networks for Hub and Spoke
resource "azurerm_virtual_network" "hub" {
  name                = "hub-vnet"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_virtual_network" "spoke" {
  name                = "spoke-vnet"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = ["10.1.0.0/16"]
}

# Virtual Hub for Azure Virtual WAN
resource "azurerm_virtual_hub" "virtual_hub" {
  name                = "hub-virtual-hub"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  sku                 = "Standard"
  address_prefix      = "10.0.0.0/16"
}

# Virtual Hub Connection
resource "azurerm_virtual_hub_connection" "hub_connection" {
  name                      = "hub-to-spoke-connection"
  virtual_hub_id            = azurerm_virtual_hub.virtual_hub.id
  remote_virtual_network_id = azurerm_virtual_network.spoke.id
  internet_security_enabled = true
}

# ExpressRoute Gateway for Virtual Hub
resource "azurerm_express_route_gateway" "expressroute_gateway" {
  name                = "hub-expressroute-gateway"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  virtual_hub_id      = azurerm_virtual_hub.virtual_hub.id
  scale_units         = 2
}

# Subnets for Hub and Spoke

resource "azurerm_subnet" "spoke_subnet" {
  name                 = "spoke-subnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.1.1.0/24"]
}

# Management Subscription Resources

resource "azurerm_policy_assignment" "management_policy_assignment" {
  name                 = "management-policy-assignment"
  scope                = azurerm_resource_group.hub.id
  policy_definition_id = azurerm_policy_definition.management_policy_definition.id
}

resource "azurerm_active_directory_domain_service" "management_domain_service" {
  name                         = "management-ad-ds"
  resource_group_name          = azurerm_resource_group.hub.name
  location                     = azurerm_resource_group.hub.location
  domain_name                  = "managementdomain.local"
  domain_security_level       = "Enhanced"
  ldaps_enabled               = true
  replicas                    = 2
}

# Connectivity Subscription Resources




resource "azurerm_express_route_circuit" "connectivity_express_route" {
  name                = "connectivity-expressroute-circuit"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  sku                 = "Standard_MeteredData"
  bandwidth_in_mbps  = 200
  service_provider_name = "Equinix"
  peering_location     = "Silicon Valley"
  allow_classic_operations = true
}

resource "azurerm_network_security_group" "connectivity_nsg" {
  name                = "connectivity-nsg"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
}

resource "azurerm_network_security_rule" "allow_inbound_traffic" {
  name                        = "allow-inbound-traffic"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.connectivity_nsg.name
  resource_group_name         = azurerm_resource_group.hub.name
}

resource "azurerm_public_ip" "connectivity_public_ip" {
  name                = "connectivity-public-ip"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

```