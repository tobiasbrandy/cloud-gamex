variable "vpc_id" {
  description = "VPC ID"
  type        = string
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

variable "execution_role_arn" {
  description = "Arn of role for service execution"
  type        = string
}

variable "task_role_arn" {
  description = "Arn of role for service task"
  type        = string
}

variable "alb_target_groups" {
  description = "Target groups of ALB redirecting to services"
  type        = map
}

variable "environment" {
  description = "Environment variables available to all services. List of name/value pairs."
  type        = list(map(string))
  default     = null
}

