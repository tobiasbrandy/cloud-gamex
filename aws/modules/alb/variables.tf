variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
}

variable "services" {
  description = "Services definition by name"
  type        = map(map(any))
}

variable "path_prefix" {
  description = "Path prefix for all services"
  type        = string
}

variable "cdn_secret_header" {
  description = "Header where secret between ALB and CDN travels"
  type        = string
}

variable "cdn_secret" {
  description = "Secret between ALB and CDN"
  type        = string
}

