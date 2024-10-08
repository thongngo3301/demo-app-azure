variable "zone_id" {
  type        = string
  description = "The zone identifier to target for the resource. Modifying this attribute will force creation of a new resource."
  default     = ""
}

variable "name" {
  type        = string
  description = "The name of the record. Modifying this attribute will force creation of a new resource."
  default     = ""
}

variable "type" {
  type        = string
  description = "The type of the record. Available values: A, AAAA, CAA, CNAME, TXT, SRV, LOC, MX, NS, SPF, CERT, DNSKEY, DS, NAPTR, SMIMEA, SSHFP, TLSA, URI, PTR, HTTPS, SVCB. Modifying this attribute will force creation of a new resource."
  default     = ""
}

variable "proxied" {
  type        = bool
  description = "Whether the record gets Cloudflare's origin protection."
  default     = true
}

variable "comment" {
  type        = string
  description = "Comments or notes about the DNS record. This field has no effect on DNS responses."
  default     = ""
}

variable "value" {
  type        = string
  description = "The value of the record."
  default     = ""
}

variable "allow_overwrite" {
  type        = bool
  description = "(Boolean) Allow creation of this record in Terraform to overwrite an existing record, if any. This does not affect the ability to update the record in Terraform and does not prevent other resources within Terraform or manual changes outside Terraform from overwriting this record. This configuration is not recommended for most environments. Defaults to false."
  default     = false
}
