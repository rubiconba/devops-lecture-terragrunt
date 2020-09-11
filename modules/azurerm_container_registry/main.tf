# This module manages Azure Container Registry

resource "azurerm_container_registry" "container_registry" {
  name                = var.container_registry_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = true

  tags = {
    environment = var.environment
  }
}
