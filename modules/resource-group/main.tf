resource "azurerm_resource_group" "rg-main" {
  name     = var.resource_group_name
  location = var.location
}