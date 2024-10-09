variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group where the Linux Web App should exist. Changing this forces a new Linux Web App to be created."
  default     = ""
}

variable "app_name" {
  type        = string
  description = "The name which should be used for this Linux Web App. Changing this forces a new Linux Web App to be created."
  default     = ""
}

variable "app_location" {
  type        = string
  description = "The Azure Region where the Linux Web App should exist. Changing this forces a new Linux Web App to be created."
  default     = ""
}

variable "app_sku" {
  type        = string
  description = "The SKU for the plan. Possible values include B1, B2, B3, D1, F1, I1, I2, I3, I1v2, I2v2, I3v2, I4v2, I5v2, I6v2, P1v2, P2v2, P3v2, P0v3, P1v3, P2v3, P3v3, P1mv3, P2mv3, P3mv3, P4mv3, P5mv3, S1, S2, S3, SHARED, EP1, EP2, EP3, FC1, WS1, WS2, WS3, and Y1."
  default     = "F1"
}

variable "app_settings" {
  type        = map(any)
  description = "A map of key-value pairs of App Settings"
  default     = {}
}

variable "subnet_id" {
  type        = string
  description = "The subnet id which will be used by this Web App for regional virtual network integration."
  default     = ""
}

variable "docker_image_name" {
  type        = string
  description = "The docker image, including tag, to be used. e.g. appsvc/staticsite:latest."
  default     = ""
}

variable "docker_registry_url" {
  type        = string
  description = "The URL of the container registry where the docker_image_name is located. e.g. https://index.docker.io or https://mcr.microsoft.com. This value is required with docker_image_name."
  default     = ""
}

variable "custom_domain_name" {
  type        = string
  description = "Specifies the Custom Hostname to use for the App Service, example www.example.com. Changing this forces a new resource to be created."
  default     = ""
}
