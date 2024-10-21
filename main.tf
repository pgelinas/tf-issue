terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.116.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_service_plan" "app_service_plan" {
  name                = "fake"
  location            = "canadacentral"
  resource_group_name = "rg"
  os_type             = "Linux"
  sku_name            = "P1v3"
}

module "function_app" {
  source               = "./function_app"
  app_service_plan_id  = azurerm_service_plan.app_service_plan.id
  docker_configuration = {
    registry_url      = "fake"
    image_name        = "fake"
    image_tag         = "fake"
    registry_username = "fake"
    registry_password = "fake"
  }
}
