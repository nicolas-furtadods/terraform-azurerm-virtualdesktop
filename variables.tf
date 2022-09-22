##########################################################################
# 0. Global Configuration
##########################################################################
variable "subscription_id" {
  description = "Resources created for the governance will use this subscription."
  type        = string
}

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
  default = {}
}

variable "resource_group_name" {
  description = "Name of the resource group where resources will be created"
  type        = string
}

##########################################################################
# 1. Virtual Network Configuration
##########################################################################
/*
variable "subnet_id" {
  description = "A subnet ID needed to create the gateway resource"
  type        = string
}
*/