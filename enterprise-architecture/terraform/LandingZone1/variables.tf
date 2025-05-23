variable "suffix" {
  type = string
}

variable "resource_group_location" {
  type    = string
  default = "Japan East"
}

variable "virtual_hub_id" {
  type = string
}

variable "firewall_id" {
  type = string
}

variable "vnet_address" {
  type = string
}

variable "subnet_address" {
  type = list(string)
}

variable "vm_password" {
  type = string
}
