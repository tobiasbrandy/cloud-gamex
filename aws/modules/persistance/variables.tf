variable "vpc_id" {
  type        = string
  description = "VPC ID to create the cluster in (e.g. `vpc-a22222ee`)"
}

variable "persistance_subnets" {
  description = "Persistance subnets for database layer"
  type        = list(string)
}


variable "skip_final_snapshot" {
  default = true
  type    = bool
}

variable "vpc_cidr" {
  type = string
}


