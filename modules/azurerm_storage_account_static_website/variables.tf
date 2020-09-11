# Input variables for Static Website module

variable "name" {
  type        = string
  description = "The name of the storage account."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the storage account."
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists."
}

variable "account_tier" {
  type        = string
  description = "Defines the Tier to use for this storage account."
}

variable "account_replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account."
}

variable "access_tier" {
  type        = string
  description = "Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts."
}

variable "environment" {
  type        = string
  description = "Tags which should be assigned to the storage account."
}

variable "index_document" {
  type        = string
  default     = "index.html"
  description = "The webpage that Azure Storage serves for requests to the root of a website or any subfolder."
}

variable "error_404_document" {
  type        = string
  default     = "404.html"
  description = "The absolute path to a custom webpage that should be used when a request is made which does not correspond to an existing file."
}