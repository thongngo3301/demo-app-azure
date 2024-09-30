resource "random_id" "rg_name" {
  byte_length = 8
}

resource "azurerm_resource_group" "example" {
  location = try(local.values.location, null)
  name     = "test-${random_id.rg_name.hex}-rg"
}

resource "azurerm_network_security_group" "default" {
  location            = try(local.values.location, null)
  name                = "test-${random_id.rg_name.hex}-nsg"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_route_table" "default" {
  location            = try(local.values.location, null)
  name                = "test-${random_id.rg_name.hex}-rt"
  resource_group_name = azurerm_resource_group.example.name
}

module "vnet" {
  source              = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  use_for_each        = true
  address_space       = try(local.values.vnet.cidr, null)
  subnet_prefixes     = [ for x in try(local.values.vnet.subnets, [{}]) : x.prefix ]
  subnet_names        = [ for x in try(local.values.vnet.subnets, [{}]) : x.name ]
  vnet_location       = try(local.values.location, null)

  nsg_ids = { for x in try(local.values.vnet.subnets, [{}]) : x.name => azurerm_network_security_group.default.id }

  subnet_service_endpoints = {
    subnet2 = ["Microsoft.Storage", "Microsoft.Sql"],
    subnet3 = ["Microsoft.AzureActiveDirectory"]
  }

  subnet_delegation = {
    subnet2 = {
      "Microsoft.Sql.managedInstances" = {
        service_name = "Microsoft.Sql/managedInstances"
        service_actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
          "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
          "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
        ]
      }
    }
  }

  route_tables_ids = {
    subnet1 = azurerm_route_table.rt1.id
  }

  tags = {
    environment = "dev"
    costcenter  = "it"
  }

  subnet_enforce_private_link_endpoint_network_policies = {
    subnet2 = true
  }

  subnet_enforce_private_link_service_network_policies = {
    subnet3 = true
  }
}

module "postgresql" {
  source = "Azure/postgresql/azurerm"

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  server_name                   = "examples-server"
  sku_name                      = "GP_Gen5_2"
  storage_mb                    = 5120
  auto_grow_enabled             = false
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false
  administrator_login           = "login"
  administrator_password        = "password"
  server_version                = "9.5"
  ssl_enforcement_enabled       = true
  public_network_access_enabled = true
  db_names                      = ["my_db1", "my_db2"]
  db_charset                    = "UTF8"
  db_collation                  = "English_United States.1252"

  firewall_rule_prefix = "firewall-"
  firewall_rules = [
    { name = "test1", start_ip = "10.0.0.5", end_ip = "10.0.0.8" },
    { start_ip = "127.0.0.0", end_ip = "127.0.1.0" },
  ]

  vnet_rule_name_prefix = "postgresql-vnet-rule-"
  vnet_rules = [
    { name = "subnet1", subnet_id = "<subnet_id>" }
  ]

  tags = {
    Environment = "Production",
    CostCenter  = "Contoso IT",
  }

  postgresql_configurations = {
    backslash_quote = "on",
  }
}
