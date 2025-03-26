# ----------------------------------------------------------------------------------------------
# Azure Policy Definition
# ----------------------------------------------------------------------------------------------
resource "azurerm_policy_definition" "this" {
  name         = "management-policy-definition"
  policy_type  = "Custom"
  display_name = "Management Policy"
  mode         = "All"
  policy_rule  = "{ \"if\": { \"field\": \"location\", \"equals\": \"East US\" }, \"then\": { \"effect\": \"audit\" } }"
  description  = "Policy for managing resources in the East US region"
}
