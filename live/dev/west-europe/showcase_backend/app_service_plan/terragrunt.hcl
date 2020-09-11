# Configuration for App Service Plan used by the backend api

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

  app_service_plan_name = "asp-${local.project}-${local.env}-${local.suffix}"
}

# Specify the path to the source of the module
terraform {
  source = "../../../../../modules//azurerm_app_service_plan"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# An App Service Plan must be created inside a resource group
dependency "resource_group" {
  config_path = "../../resource_group"
  mock_outputs = {
    resource_name = "mockOutput"
  }
}

# Set the input variables for the App Service Plan module
inputs = {
  name                = local.app_service_plan_name
  location            = local.location
  resource_group_name = dependency.resource_group.outputs.resource_name

  kind = "linux"

  sku_tier = "Basic"
  sku_size = "B1"

  # This variable must be set to true if App Service Plan kind is linux
  reserved = true

  environment = local.env
}
