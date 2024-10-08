variable "api_token" {
  default     = ""
  description = "My Cloudflare API token for Terraform to interact"
  type        = string
}

variable "zone_id" {
  default     = ""
  description = "ID of DNS zone"
  type        = string
}

variable "psql_db_user" {
  default     = ""
  description = "PSQL user"
  type        = string
}

variable "psql_db_password" {
  default     = ""
  description = "PSQL password"
  type        = string
}

variable "docker_registry" {
  default     = ""
  description = "Docker registry for app"
  type        = string
}

variable "docker_image" {
  default     = ""
  description = "Docker image for app"
  type        = string
}

variable "env" {
  default     = ""
  description = "Environment to apply Terraform"
  type        = string
}
