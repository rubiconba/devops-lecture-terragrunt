# Input variables for Container Registry Module

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Container Registry."
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists."
}

variable "environment" {
  type        = string
  description = "Tags which should be assigned to the resource."
}

variable "container_registry_name" {
  type        = string
  description = "Specifies the name of the Container Registry."
}

variable "sku" {
  type        = string
  description = "The SKU name of the container registry."
}
