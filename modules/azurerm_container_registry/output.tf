# Output variables for Container Registry Module

output "login_server" {
  value       = "https://${azurerm_container_registry.container_registry.login_server}"
  description = "The URL that can be used to log into the container registry."
}

output "registry_name" {
  value       = azurerm_container_registry.container_registry.name
  description = "The name of the Container Registry."
}

output "admin_password" {
  value       = azurerm_container_registry.container_registry.admin_password
  sensitive   = true
  description = "The Password associated with the Container Registry Admin account - if the admin account is enabled."
}
