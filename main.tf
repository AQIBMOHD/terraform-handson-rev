terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tf-statefile"
    storage_account_name = "tfstateaqib123"
    container_name       = "tfstate"
    key                  = "aqib.tfstate"

  }
}


locals {
  common_tags = {
    Environment = "Dev"
    Project     = "Azure Infra"
    Owner       = "Aqib"
    ManagedBy   = "Terraform"

  }

  frontend_port_name = "appgw-port"
}

module "resource-group" {
  source = "./modules/resource-group"

  resource_group_name = var.resource_group_name
  location            = var.location

}


module "network" {
  source = "./modules/network"

  resource_group_name                = module.resource-group.rg_name
  location                           = var.location
  vnet_hub_name                      = var.vnet_hub_name
  vnet_hub_address_space             = var.vnet_hub_address_space
  vnet_frontend_subnet_name          = var.vnet_frontend_subnet_name
  vnet_frontend_subnet_address_space = var.vnet_frontend_subnet_address_space
  vnet_backend_subnet_name           = var.vnet_backend_subnet_name
  vnet_backend_subnet_address_space  = var.vnet_backend_subnet_address_space
  frontend_nsg_name                  = var.frontend_nsg_name
  backend_nsg_name                   = var.backend_nsg_name
  appgw_subnet_name                  = var.appgw_subnet_name
  appgw_subnet_address_space         = var.appgw_subnet_address_space
  tags                               = local.common_tags
}

module "appgateway" {
  source = "./modules/app-gateway"


  resource_group_name = module.resource-group.rg_name
  appgw_subnet_id     = module.network.appgw_subnet_id
  location            = var.location


}

module "compute" {
  source              = "./modules/compute"
  resource_group_name = module.resource-group.rg_name
  location            = var.location
  admin_username      = "adminaqib"
  admin_password      = var.admin_password
  # Yahan hum Network module ke outputs ko Compute module mein bhej rahe hain!
  frontend_subnet_id = module.network.frontend_subnet_id
  backend_subnet_id  = module.network.backend_subnet_id
  frontend_pip_id    = module.network.frontend_vm_ip
  tags               = local.common_tags
  















}

















































