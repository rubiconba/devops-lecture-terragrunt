# Configuration file for backend App Service

locals {
  # Automatically load environment-level variables from files in parent folders
  location_vars = read_terragrunt_config(find_in_parent_folders("location.hcl"))
  env_vars      = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  global_vars   = read_terragrunt_config(find_in_parent_folders("global.hcl"))

  # Extract out common variables for reuse
  location = local.location_vars.locals.location
  env      = local.env_vars.locals.env
  suffix   = local.env_vars.locals.suffix
  project  = local.global_vars.locals.project

  app_service_name = "azapp-${local.project}-${local.env}-${local.suffix}"
}

# Specify the path to the source of the module
terraform {
  source = "../../../../../modules//azurerm_app_service"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# To create an App Service we need a resource group in which it will be created
dependency "resource_group" {
  config_path = "../../resource_group"
  mock_outputs = {
    resource_name = "mockOutput"
  }
}

# To create an App Service we need an App Service Plan in which it will be created 
dependency "app_service_plan" {
  config_path = "../app_service_plan"
  mock_outputs = {
    id = "mockOutput"
  }
}

# Get the public web endpoints from the frontend module, so we can add them to the CORS list
dependency "showcase_frontend" {
  config_path = "../../showcase_frontend"
  mock_outputs = {
    primary_web_endpoint   = "mockOutput"
    secondary_web_endpoint = "mockOutput"
  }
}

# Container registry in which the backend docker image will be deployed
dependency "container_registry" {
  config_path = "../container_registry"
  mock_outputs = {
    admin_password = "mockOutput"
    registry_name  = "mockOutput"
  }
}

# Input variables specific for the App Service module
inputs = {
  name                = local.app_service_name
  location            = local.location
  resource_group_name = dependency.resource_group.outputs.resource_name

  app_service_plan_id = dependency.app_service_plan.outputs.id

  allowed_origins = [
    "https://${dependency.showcase_frontend.outputs.primary_web_endpoint}",
    "https://${dependency.showcase_frontend.outputs.secondary_web_endpoint}"
  ]

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"                       = "https://index.docker.io"
    "DOCKER_REGISTRY_SERVER_USERNAME"                  = dependency.container_registry.outputs.registry_name
    "DOCKER_REGISTRY_SERVER_PASSWORD"                  = dependency.container_registry.outputs.admin_password
    "DOCKER_ENABLE_CI"                                 = "true"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE"              = "false"
  }
}
