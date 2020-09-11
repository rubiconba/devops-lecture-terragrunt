# Configuration for Resource Group module

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

  resource_group_name = "rg-${local.project}-${local.env}-${local.suffix}"
}

# Specify the path to the source of the module
terraform {
  source = "../../../../modules//azurerm_resource_group"
}

# Include all settings from the root terragrunt.hcl file
include {
  # find_in_parent_folders() searches up the directory tree from the current .tfvars 
  # file and returns the relative path to to the first terraform.tfvars in a parent folder 
  # or exit with an error if no such file is found
  path = find_in_parent_folders()
}

# Set inputs to pass as variables to the module
inputs = {
  name        = local.resource_group_name
  location    = local.location
  environment = local.env
}