# Output variables for the Static Website module

output "name" {
  value       = azurerm_storage_account.storage_account.name
  description = "Output name of the storage account."
}

output "primary_connection_string" {
  value       = azurerm_storage_account.storage_account.primary_connection_string
  sensitive   = true
  description = "The connection string associated with the primary location."
}

output "primary_access_key" {
  value       = azurerm_storage_account.storage_account.primary_access_key
  sensitive   = true
  description = "The primary access key for the storage account."
}

output "primary_web_endpoint" {
  value       = azurerm_storage_account.storage_account.primary_web_host
  description = "The endpoint URL for web storage in the primary location."
}

output "secondary_web_endpoint" {
  value       = azurerm_storage_account.storage_account.secondary_web_host
  description = "The endpoint URL for web storage in the secondary location."
}