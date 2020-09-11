# This module manages an Azure App Service

resource "azurerm_app_service" "app_service" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = var.app_service_plan_id

  https_only = true

  site_config {
    linux_fx_version = "DOCKER|${var.appservice_docker_image}"
    always_on        = true
    scm_type         = "VSTSRM"
    cors {
      allowed_origins = var.allowed_origins
    }
  }

  app_settings = var.app_settings

  # This block will create a connection_string block for each connection string 
  # in the input variable connection_strings
  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = connection_string.value["name"]
      value = connection_string.value["value"]
      type  = connection_string.value["type"]
    }
  }

  # Deployments are made outside of Terraform
  lifecycle {
    ignore_changes = [
      site_config.0.linux_fx_version, 
      app_settings["DOCKER_REGISTRY_SERVER_URL"],
    ]
  }
}
