terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.23.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.29.0"
    }
  }
}

data "azurerm_client_config" "current" {
}