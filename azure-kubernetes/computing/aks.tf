# ----------------------------------------------------------------------------------------------
# Azure Container Registry
# ----------------------------------------------------------------------------------------------
resource "azurerm_container_registry" "this" {
  name                = "acr-${var.suffix}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = "Basic"
  admin_enabled       = false
}

# ----------------------------------------------------------------------------------------------
# Azure Kubernetes Cluster
# ----------------------------------------------------------------------------------------------
resource "azurerm_kubernetes_cluster" "this" {
  name                = "aks-cluster-${var.suffix}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  # dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }



  identity {
    type = "SystemAssigned"
  }

}
