terraform {
  required_version = ">= 1.3"

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"             # change if different
    storage_account_name = "tfstate<uniqueid>"      # must exist
    container_name       = "tfstate"
    key                  = "octabyte.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.70.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.5.0"
    }
  }
}

provider "azurerm" {
  features {}
}
