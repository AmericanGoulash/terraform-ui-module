variable "top_private_domain" {
  description = "Top UI hosting bucket (e.g., dev.example.com)"
}

variable "www_domain" {
  description = "Domain with the www.* prefix"
}

variable "wildcard_certificate_arn" {
  description = "wildcard certificate value"
}

variable "route53_zone_id" {
  description = "zone id of the hosted route53"
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
