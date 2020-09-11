# This module manages an Azure App Service Plan

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  kind = var.kind

  sku {
    tier     = var.sku_tier
    size     = var.sku_size
    capacity = var.sku_capacity
  }

  reserved = var.reserved

  tags = {
    environment = var.environment
  }
}