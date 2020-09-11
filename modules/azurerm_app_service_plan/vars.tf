# Input variables for the App Service Plan module

variable "name" {
  type        = string
  description = "The name of the App Service Plan."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the App Service Plan component."
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists."
}

variable "kind" {
  type        = string
  description = "The kind of the App Service Plan to create. Possible values are Windows, Linux, elastic and FunctinoApp."
}

variable "sku_tier" {
  type        = string
  description = "Specifies the plan's pricing tier."
}

variable "sku_size" {
  type        = string
  description = "Specifies the plan's instance size."
}

variable "sku_capacity" {
  type        = number
  default     = null
  description = "Specifies the number of workers associated with this App Service Plan."
}

# Must be set to true if App Service Plan kind is Linux
variable "reserved" {
  type        = bool
  default     = false
  description = "Is this App Service Plan Reserved."
}

variable "environment" {
  type        = string
  description = "The environment of the App Service Plan."
}
