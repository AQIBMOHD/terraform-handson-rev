variable "resource_group_name" {
  type = string

}

variable "location" {
  type = string
}

variable "vnet_hub_name" {
  type = string
}

variable "vnet_hub_address_space" {
  type = list(string)
}

variable "vnet_frontend_subnet_name" {
  type = string
}

variable "vnet_frontend_subnet_address_space" {
  type = list(string)
}

variable "vnet_backend_subnet_address_space" {
  type = list(string)

}

variable "vnet_backend_subnet_name" {
  type = string
}

variable "frontend_nsg_name" {
  type = string
}

variable "backend_nsg_name" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}



