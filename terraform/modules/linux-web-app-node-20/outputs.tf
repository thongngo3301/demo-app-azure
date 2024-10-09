output "domain" {
  value = azurerm_linux_web_app.main.default_hostname
}

output "custom_domain_verification_id" {
  value = azurerm_linux_web_app.main.custom_domain_verification_id
}
