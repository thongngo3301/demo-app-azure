data "azurerm_resource_group" "rg" {
  name = "${local.values.prefix}-${var.env}-${try(local.values.webapp.resource_group_name, "")}"
}

data "azurerm_subnet" "subnet" {
  name                 = try(local.values.webapp.subnet, "")
  virtual_network_name = "${local.values.prefix}-${var.env}-${try(local.values.webapp.vnet, "")}"
  resource_group_name  = data.azurerm_resource_group.rg.name
}

data "azurerm_postgresql_server" "psql_server" {
  name                = "${local.values.prefix}-${var.env}-${try(local.values.webapp.psql_server_name, "")}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

module "webapp" {
  source = "./modules/linux-web-app-node-20"

  resource_group_name = data.azurerm_resource_group.rg.name
  app_location        = data.azurerm_resource_group.rg.location
  app_name            = "${local.values.prefix}-${var.env}-${try(local.values.webapp.name, "")}"
  app_sku             = try(local.values.webapp.sku, "")
  app_settings = {
    PG_HOST     = data.azurerm_postgresql_server.psql_server.fqdn
    PG_PORT     = try(local.values.webapp.psql_db_port, 5432)
    PG_DATABASE = try(local.values.webapp.psql_db_name, "")
    PG_USER     = "${var.psql_db_user}@${data.azurerm_postgresql_server.psql_server.name}"
    PG_PASSWORD = var.psql_db_password
  }
  subnet_id           = data.azurerm_subnet.subnet.id
  docker_registry_url = "https://${var.docker_registry}"
  docker_image_name   = var.docker_image
}

# module "dns" {
#   source  = "./modules/dns"
#   zone_id = var.zone_id
#   name    = try(local.values.dns.name, "")
#   type    = try(local.values.dns.type, "")
#   proxied = try(local.values.dns.proxied, true)
#   comment = try(local.values.dns.comment, "")
#   value   = module.webapp.domain
# }
