terraform {
  required_version = ">=1.4.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.56.0"
    }
  }
}

provider "azurerm" {
  features {

  }
}

resource "azurerm_resource_group" "rg-itqueiroz-impacta-eastus-cloud" {
  name     = "rg-itqueiroz-impacta-eastus-cloud"
  location = "East US"
}
