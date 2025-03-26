variable "suffix" {
  type = string
}

variable "resource_group_location" {
  type    = string
  default = "Japan East"
}

variable "vhub_address_prefix" {
  type = string
}

variable "vnet_address" {
  type = string
}

variable "subnet_address_firewall" {
  type = string
}

variable "subnet_address_gateway" {
  type = string
}
