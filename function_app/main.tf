variable "docker_configuration" {
  type = object({
    registry_url = string
    image_name = string
    image_tag = string
    registry_username = string
    registry_password = string
  })
  sensitive = true
  default = null
}

variable "app_service_plan_id" {}

resource "azurerm_linux_function_app" "function_app" {
  name                = "name"
  resource_group_name = "rg"
  location            = "canadacentral"

  storage_account_name = "fakestorage"
  service_plan_id               = var.app_service_plan_id
  functions_extension_version   = "~4"
  https_only                    = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on         = true

    application_stack {
      dynamic "docker" {
        # This still crashes
        # for_each = nonsensitive(var.docker_configuration[*])
        for_each = var.docker_configuration[*]
        content {
          registry_url      = var.docker_configuration.registry_url
          image_name        = var.docker_configuration.image_name
          image_tag         = var.docker_configuration.image_tag
          registry_username = var.docker_configuration.registry_username
          registry_password = var.docker_configuration.registry_password
        }
      }
    }
  }
}
