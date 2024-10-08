resource "cloudflare_record" "main" {
  zone_id         = var.zone_id
  name            = var.name
  type            = var.type
  proxied         = var.proxied
  comment         = var.comment
  content         = var.value
  allow_overwrite = var.allow_overwrite
}
