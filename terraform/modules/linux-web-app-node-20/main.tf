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

module "txt_record" {
  source  = "../dns"
  zone_id = var.cf_zone_id
  name    = "asuid.${split(".", var.custom_domain_name)[0]}"
  type    = "TXT"
  proxied = false
  comment = "TXT verification record"
  value   = azurerm_linux_web_app.main.custom_domain_verification_id
}

resource "time_sleep" "wait_for_30s" {
  depends_on = [
    module.txt_record
  ]
  create_duration = "30s"
}

resource "azurerm_app_service_custom_hostname_binding" "main" {
  hostname            = var.custom_domain_name
  app_service_name    = azurerm_linux_web_app.main.name
  resource_group_name = var.resource_group_name
  depends_on = [
    time_sleep.wait_for_30s
  ]
}
