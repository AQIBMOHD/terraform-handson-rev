output "frontend_subnet_id" {
    value = azurerm_subnet.fsnet.id
}
output "backend_subnet_id" {
    value = azurerm_subnet.bsnet.id
}
output "frontend_vm_ip" {
    value = azurerm_public_ip.frontend-pip.id
}
