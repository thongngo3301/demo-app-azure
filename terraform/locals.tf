locals {
  values = yamldecode(file("./values/${var.env}.yaml"))
  vnet_values = try(local.values.vnet, {})
}