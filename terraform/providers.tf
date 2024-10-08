terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4"
    }
  }
}

provider "azurerm" {
  environment = "public"
  use_oidc    = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "cloudflare" {
  api_token = var.api_token
}
