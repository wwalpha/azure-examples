variable "resource_group_name" {
  default = "s2s-vpn"
}

variable "resource_group_location" {
  default = "Japan East"
}

variable "pre_shared_key" {
}

variable "aws_virtual_private_gateway" {
}

variable "aws_address_spaces" {
  default = "10.0.0.0/8"
}
