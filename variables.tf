variable ssh_key_path {
  description = "SSH public key location needed to access aws instances"
  type        = string
}

variable my_ips {
  description = "Public IPs of the user. AWS EC2 access is restricted to those IPs."
  type        = list(string)
}

variable aws_region {
  description = "AWS Region in which to deploy the application"
  type = string
  }

variable app_domain {
  description = "Base domain for the whole application. A subdomain of an already established domain."
  type = string
  }

  variable authorized_role {
  description = "Name of the role to use throughout the application deployment. We only support a single super-user."
  type = string
  }

