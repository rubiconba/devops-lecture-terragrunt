# Configuration for Container Registry

# Loads configuration from parent folders of common variables like Location and Environment
locals {
  location_vars = read_terragrunt_config(find_in_parent_folders("location.hcl"))
  env_vars      = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  global_vars   = read_terragrunt_config(find_in_parent_folders("global.hcl"))

  location = local.location_vars.locals.location
  env      = local.env_vars.locals.env
  suffix   = local.env_vars.locals.suffix
  project  = local.global_vars.locals.project

  container_registry_name = "reg${local.project}${local.env}${local.suffix}"
}

# Specify the path to the source of the module
terraform {
  source = "../../../../../modules//azurerm_container_registry"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# Dependency on the resource group in which the container registry will be created
dependency "resource_group" {
  config_path = "../../resource_group"
  mock_outputs = {
    resource_name = "mockOutput"
  }
}

# Set inputs to pass as variables to the module
inputs = {
  container_registry_name = local.container_registry_name
  location                = local.location
  resource_group_name     = dependency.resource_group.outputs.resource_name
  sku                     = "Basic"

  environment = local.env
}
