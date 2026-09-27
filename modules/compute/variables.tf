variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "frontend_subnet_id" {
  type = string

}

variable "backend_subnet_id" {
  type = string
}

variable "frontend_pip_id" {
  type = string
}



variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "tags" {
    type = map(string)
}

