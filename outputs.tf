output "frontend_vm_public_ip" {
  #   value = azurerm_public_ip.frontend-pip.ip_address
  value = module.network.frontend_vm_ip
}