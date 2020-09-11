# This module manages an azure storage account used to host a static website.

resource "azurerm_storage_account" "storage_account" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  # Storage account kind needs to be "StorageV2" to support static website hosting
  account_kind              = "StorageV2"
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  access_tier               = var.access_tier
  enable_https_traffic_only = true

  tags = {
    environment = var.environment
  }

  static_website {
    index_document     = var.index_document
    error_404_document = var.error_404_document
  }
}