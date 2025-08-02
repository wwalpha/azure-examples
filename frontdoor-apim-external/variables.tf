# Variables
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "frontdoor-apim-function"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "Japan East"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = ""
}

variable "vnet_address_space" {
  description = "Virtual network address space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "apim_subnet_address_prefix" {
  description = "APIM subnet address prefix"
  type        = string
  default     = "10.0.1.0/24"
}

variable "function_subnet_address_prefix" {
  description = "Function subnet address prefix"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_endpoint_subnet_address_prefix" {
  description = "Private endpoint subnet address prefix"
  type        = string
  default     = "10.0.3.0/24"
}

variable "apim_sku_name" {
  description = "APIM SKU name"
  type        = string
  default     = "Developer_1"
  validation {
    condition = contains([
      "Developer_1", "Standard_1", "Premium_1"
    ], var.apim_sku_name)
    error_message = "APIM SKU must be Developer_1, Standard_1, or Premium_1."
  }
}

variable "function_app_sku" {
  description = "Function App SKU (Premium V3: P0V3, P1V3, P2V3, P3V3)"
  type        = string
  default     = "P1v3"
  validation {
    condition = contains([
      "P0v3", "P1v3", "P2v3", "P3v3"
    ], var.function_app_sku)
    error_message = "Function App SKU must be Premium V3 (P0V3, P1V3, P2V3, P3V3)."
  }
}

variable "publisher_name" {
  description = "APIM publisher name"
  type        = string
  default     = "API Administrator"
}

variable "publisher_email" {
  description = "APIM publisher email"
  type        = string
  default     = "admin@example.com"
}
