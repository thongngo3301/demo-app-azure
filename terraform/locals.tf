locals {
  global_values = yamldecode(file("./values/global.yaml"))
  env_values    = yamldecode(file("./values/${var.env}.yaml"))

  values = merge(global_values, env_values)
}
