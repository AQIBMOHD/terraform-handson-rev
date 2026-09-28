resource "azurerm_virtual_network" "vnet-main" {
  name                = var.vnet_hub_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_hub_address_space
    tags = var.tags



}

resource "azurerm_subnet" "fsnet" {
  name                 = var.vnet_frontend_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-main.name
  address_prefixes     = var.vnet_frontend_subnet_address_space



}

resource "azurerm_subnet" "bsnet" {
  name                 = var.vnet_backend_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-main.name
  address_prefixes     = var.vnet_backend_subnet_address_space
    



}

resource "azurerm_network_security_group" "frontend-nsg" {
  name                = var.frontend_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
    tags = var.tags


}

resource "azurerm_network_security_group" "backend-nsg" {
  name                = var.backend_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
    tags = var.tags



}

resource "azurerm_network_security_rule" "allow-ssh-frontend" {
  name                        = "allow-ssh-frontend"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "14.194.103.150"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.frontend-nsg.name 


}

resource "azurerm_network_security_rule" "frontend_http" {
  name                        = "allow-http-frontend"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.frontend-nsg.name


}

resource "azurerm_subnet_network_security_group_association" "frontend-association" {
  subnet_id                 = azurerm_subnet.fsnet.id
  network_security_group_id = azurerm_network_security_group.frontend-nsg.id
    


}


resource "azurerm_public_ip" "frontend-pip" {
  name                = "pip-frontend"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
    tags = var.tags


}


resource "azurerm_network_security_rule" "backend_ssh" {
  name                        = "allow-ssh-from-frontend"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  
  //It only allows traffic from the frontend subnet.
  # Note the 's' at the end of source_address_prefixes because your variable is a list!
  source_address_prefixes     = var.vnet_frontend_subnet_address_space
  
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.backend-nsg.name 
}


resource "azurerm_subnet_network_security_group_association" "backend" {
  subnet_id                 = azurerm_subnet.bsnet.id
  network_security_group_id = azurerm_network_security_group.backend-nsg.id
    


}

resource "azurerm_public_ip" "backend_pip" {
  name                = "pip-backend"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
    tags = var.tags


}


resource "azurerm_subnet" "appgw_snet" {

        name =  "snet-appgw"
        resource_group_name =var.resource_group_name
         virtual_network_name = azurerm_virtual_network.vnet-main.name
         address_prefixes = ["10.0.3.0/24"]

    
    

}



