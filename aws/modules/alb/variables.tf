variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
}

variable "app_subnets" {
  description = "Application subnets"
  type        = list(string)
}

variable "services" {
  description = "Services definition by name"
  type        = map(map(any))
}

variable "service_images" {
  description = "Images of services to deploy by name"
  type        = map(string)
}

variable "path_prefix" {
  description = "Path prefix for all services"
  type        = string
}

variable "execution_role_arn" {
  description = "Arn of role for service execution"
  type        = string
}

variable "task_role_arn" {
  description = "Arn of role for service task"
  type        = string
}

