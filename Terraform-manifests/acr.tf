resource "azurerm_container_registry" "acr" {
  name                     = "terraformacrsntdr"
  resource_group_name      = azurerm_resource_group.k8s.name
  location                 = azurerm_resource_group.k8s.location
  sku                      = "Premium"
  admin_enabled            = true
}