terraform {
  required_version = ">= 1.15.0"

  backend "azurerm" {
    resource_group_name  = "rg-utpdavid2026-GEN-4j"
    storage_account_name = "stgutpdavid2026gen4j"
    container_name       = "tfstate-user1"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.78.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "2.7.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}
