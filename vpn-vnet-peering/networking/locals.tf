locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
}

# ----------------------------------------------------------------------------------------------
# Azure Subscription
# ----------------------------------------------------------------------------------------------
data "azurerm_subscription" "current" {}
