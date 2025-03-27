output "test" {
  value = module.Connectivity.test.virtual_hub[0].public_ip_addresses[0]
}

output "test2" {
  value = module.Connectivity.test2
}
