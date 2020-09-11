# Input variables for Resource Group module

variable "environment" {
  type        = string
  default     = null
  description = "Tags which should be assigned to the Resource Group"
}

variable "location" {
  type        = string
  description = "The azure region where the Resource Group should exist"
}

variable "name" {
  type        = string
  description = "The name which should be used for this Resource Group."
}