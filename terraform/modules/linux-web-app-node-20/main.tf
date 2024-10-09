resource "azurerm_service_plan" "main" {
  name                = "${var.app_name}-sp"
  resource_group_name = var.resource_group_name
  location            = var.app_location
  os_type             = "Linux"
  sku_name            = var.app_sku
}

resource "azurerm_linux_web_app" "main" {
  name                = var.app_name
  resource_group_name = var.resource_group_name
  location            = var.app_location
  service_plan_id     = azurerm_service_plan.main.id

  app_settings              = var.app_settings
  virtual_network_subnet_id = var.subnet_id

  site_config {
    always_on = false
    application_stack {
      docker_image_name   = var.docker_image_name
      docker_registry_url = var.docker_registry_url
    }
  }
}

resource "azurerm_app_service_custom_hostname_binding" "example" {
  hostname            = var.custom_domain_name
  app_service_name    = azurerm_linux_web_app.main.name
  resource_group_name = var.resource_group_name
}
