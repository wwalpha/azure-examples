# output "test" {
#   value = module.Connectivity.vhub_public_ip_addresses
# }

# output "test2" {
#   value = module.Connectivity.test2
# }

output "vm_password" {
  sensitive = true
  value     = local.vm_password
}

output "server01_private_ip_address" {
  value = module.LandingZone1.azurevm_private_ip_address
}

output "server02_private_ip_address" {
  value = module.LandingZone2.azurevm_private_ip_address
}

output "virtual_hub_public_ip_addresses" {
  value = module.Connectivity.vhub_public_ip_addresses
}
