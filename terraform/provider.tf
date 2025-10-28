provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }
  required_version = ">=1.0"
}