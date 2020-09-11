# Output variables for the App Service module

output "possible_outbound_ip_addresses" {
  value       = azurerm_app_service.app_service.possible_outbound_ip_addresses
  description = "A list of possible outbound IP addresses of the App Service."
}

output "default_site_hostname" {
  value       = azurerm_app_service.app_service.default_site_hostname
  description = "The Default Hostname associated with the App Service."
}

output "default_site_url" {
  value       = "https://${azurerm_app_service.app_service.default_site_hostname}"
  description = "The Default URL associated with the App Service."
}