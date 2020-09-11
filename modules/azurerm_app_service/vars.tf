# Input variables for the App Service module

variable "name" {
  type        = string
  description = "The name of the App Service."
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the App Service."
}

variable "app_service_plan_id" {
  type        = string
  description = "The ID of the App Service Plan within which to create this App Service."
}

variable "app_settings" {
  type        = map(any)
  default     = {}
  description = "A key-value pair of App Settings."
}

variable "connection_strings" {
  type = list(object({
    name  = string
    value = string
    type  = string
  }))
  default     = []
  description = "The list of connection strings used by the App Service."
}

variable "allowed_origins" {
  type        = list(string)
  default     = []
  description = "A list of origins which should be able to make cross-origin calls."
}

variable "appservice_docker_image" {
  type        = string
  default     = "nginx:alpine"
  description = "Specify the Docker image that should be deployed to the app service"
}