# Output variables for the App Service Plan module

output "id" {
  value       = azurerm_app_service_plan.app_service_plan.id
  description = "The ID of the App Service Plan."
}

output "name" {
  value       = azurerm_app_service_plan.app_service_plan.name
  description = "The name of the App Service Plan."
}
