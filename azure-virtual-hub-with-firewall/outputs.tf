output "app_vnet_address_space" {
  value = module.networking.app_vnet_address_space
}

output "app_private_ip_address" {
  value = module.computing.app_private_ip_address
}

output "database_vnet_address_space" {
  value = module.networking.database_vnet_address_space
}

output "database_private_ip_address" {
  value = module.computing.database_private_ip_address
}
