# Outputs
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "function_app_name" {
  description = "Name of the Function App"
  value       = azurerm_linux_function_app.main.name
}

output "function_app_default_hostname" {
  description = "Default hostname of the Function App"
  value       = azurerm_linux_function_app.main.default_hostname
}

output "function_app_private_endpoint_ip" {
  description = "Private IP address of the Function App private endpoint"
  value       = azurerm_private_endpoint.function.private_service_connection[0].private_ip_address
}

output "api_management_name" {
  description = "Name of the API Management service"
  value       = azurerm_api_management.main.name
}

output "api_management_gateway_url" {
  description = "Gateway URL of API Management"
  value       = azurerm_api_management.main.gateway_url
}

output "api_management_public_ip" {
  description = "Public IP address of API Management"
  value       = azurerm_public_ip.apim.ip_address
}

# output "front_door_profile_name" {
#   description = "Name of the Front Door profile"
#   value       = azurerm_cdn_frontdoor_profile.main.name
# }

# output "front_door_endpoint_hostname" {
#   description = "Hostname of the Front Door endpoint"
#   value       = azurerm_cdn_frontdoor_endpoint.main.host_name
# }

# output "front_door_endpoint_url" {
#   description = "URL of the Front Door endpoint"
#   value       = "https://${azurerm_cdn_frontdoor_endpoint.main.host_name}"
# }

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.function.name
}

output "app_service_plan_name" {
  description = "Name of the App Service Plan"
  value       = azurerm_service_plan.function.name
}

# Test URLs
output "test_urls" {
  description = "URLs for testing the deployment"
  value = {
    # front_door      = "https://${azurerm_cdn_frontdoor_endpoint.main.host_name}/api/httpget?name=FrontDoor"
    apim_direct     = "${azurerm_api_management.main.gateway_url}/api/httpget?name=APIM"
    function_direct = "https://${azurerm_linux_function_app.main.default_hostname}/api/httpget?name=Function"
  }
}

# Debug information
output "debug_info" {
  description = "Debug information for troubleshooting"
  value = {
    function_hostname = azurerm_linux_function_app.main.default_hostname
    apim_gateway_url  = azurerm_api_management.main.gateway_url
    apim_public_ip    = azurerm_public_ip.apim.ip_address
  }
}
