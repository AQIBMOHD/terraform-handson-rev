
locals{
    frontend_vm_name = "vm-frontend"
}

resource "azurerm_network_interface" "frontend_nic" {
  name                = "nic-frontend"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags



  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.frontend_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.frontend_pip_id
  }


}

resource "azurerm_linux_virtual_machine" "frontend_vm" {
#   name                = "vm-frontend"
 name = local.frontend_vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_DC1s_v3"

  admin_username = var.admin_username
  admin_password = var.admin_password

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.frontend_nic.id


  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"

  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"

  }

  tags = var.tags


}




resource "azurerm_network_interface" "backend_nic" {
  //count               = 2
   //name                = "nic-backend-${count.index}"
  //name                = "nic-backend"
  for_each =  toset(["app", "db"])
  name = "nic-backend-${each.key}"

  location            = var.location
  resource_group_name =  var.resource_group_name
  tags = var.tags


  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.backend_subnet_id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id          = azurerm_public_ip.backend_pip.id
  }


}


resource "azurerm_linux_virtual_machine" "backend" {

  //count = 2

  //name                = "vm-backend-${count.index}"
  //name                = "vm-backend"

  for_each = toset(["app", "db"])
  name ="vm-backend-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_DC1s_v3"
  tags = var.tags


  admin_username = var.admin_username
  admin_password = var.admin_password

  disable_password_authentication = false

  network_interface_ids = [
    //azurerm_network_interface.backend_nic[count.index].id
    azurerm_network_interface.backend_nic[each.key].id
     
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"

  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"

  }

  



}






















































