# This module manages Resource Group

resource "azurerm_resource_group" "resource_group" {
  name     = var.name
  location = var.location

  tags = {
    environment = var.environment
  }
}