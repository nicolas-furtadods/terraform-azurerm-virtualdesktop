##########################################################################
# 0. Global Configuration
##########################################################################
variable "application" {
  description = "Name of the application for which the resources are created (agw,corenet etc.)"
  type        = string
}

variable "technical_zone" {
  description = "Enter a 2-digits technical zone which will be used by resources (in,ex,cm,sh)"
  type        = string

  validation {
    condition = (
      length(var.technical_zone) > 0 && length(var.technical_zone) <= 2
    )
    error_message = "The technical zone must be a 2-digits string."
  }
}
variable "environment" {
  description = "Enter the 3-digits environment which will be used by resources (hpr,sbx,prd,hyb)"
  type        = string

  validation {
    condition = (
      length(var.environment) > 0 && length(var.environment) <= 3
    )
    error_message = "The environment must be a 3-digits string."
  }
}

variable "location" {
  description = "Enter the region for which to create the resources."
}

variable "tags" {
  description = "Tags to apply to your resources"
  type        = map(string)
  default     = {}
}

variable "resource_group_name" {
  description = "Name of the resource group where resources will be created"
  type        = string
}

##########################################################################
# 1. Azure Virtual Desktop
##########################################################################
variable "applications" {
  description = "Applications Map which will serve as the basis to create the host pool and application."
  type = map(object({
    display_name = string
    virtual_machines = list(object({
      name = string
      id   = string
    }))
  }))
}

variable "avd_users" {
  description = "AVD users. They will be part of a new group."
  type        = list(string)
}
##########################################################################
# 2. Azure Virtual Desktop - Host Pool
##########################################################################
variable "host_pool_properties" {
  description = "Host Pool properties you may find on Terraform Registry"
  type        = map(any)
  default     = {}
}

variable "expiration_date" {
  description = "(Required) A valid RFC3339Time for the expiration of the token"
  type        = string
}
##########################################################################
# 3. Azure Virtual Desktop - Application Group
##########################################################################
variable "application_group_properties" {
  description = "Application group properties you may find on Terraform Registry"
  type        = map(any)
  default     = {}
}

##########################################################################
# 4. Azure Virtual Desktop - Workspace
##########################################################################
variable "workspace_properties" {
  description = "Workspace properties you may find on Terraform Registry"
  type        = map(any)
  default     = {}
}