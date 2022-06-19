provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}
data "aws_ecr_authorization_token" "token" {}

provider "docker" {
  registry_auth {
    address  = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

data "aws_iam_role" "main" {
  name = var.authorized_role
}

module "certificate" {
  source = "./aws/modules/certificate"

  app_domain   = var.app_domain
}

module "vpc" {
  source = "./aws/modules/vpc"

  cidr_block  = local.aws_vpc_network
  zones_count = local.aws_az_count
  natgw       = true
}

resource "aws_cloudfront_origin_access_identity" "cdn" {
  comment = "Origin access for CDN to the frontend"
}

module "static_site" {
  source = "./aws/modules/static_site"

  src               = local.static_resources
  bucket_access_OAI = [aws_cloudfront_origin_access_identity.cdn.iam_arn]
}

module "services" {
  source = "./services"
}

module "registry" {
  source = "./aws/modules/registry"

  services          = module.services.definitions
  services_location = "services"
}

# Secreto entre CDN y public ALB
// TODO(tobi): Rotar secreto (requiere una lambda)
module "alb_cdn_secret" {
  source = "./aws/modules/secret"

  name_prefix = "alb-cdn-secret-"
  description = "Secret between CDN and ALB"
  length      = 24
  keepers     = {
    header = local.alb_cdn_secret_header
  }
}

module "alb" {
  source = "./aws/modules/alb"

  vpc_id            = module.vpc.vpc_id
  public_subnets    = module.vpc.public_subnets_ids

  services          = module.services.definitions
  path_prefix       = "/api"

  cdn_secret_header = local.alb_cdn_secret_header
  cdn_secret        = module.alb_cdn_secret.value
}

module "ecs" {
  source = "./aws/modules/ecs"

  vpc_id                = module.vpc.vpc_id
  app_subnets           = module.vpc.app_subnets_ids
  services              = module.services.definitions
  service_images        = module.registry.service_images
  task_role_arn         = data.aws_iam_role.main.arn
  execution_role_arn    = data.aws_iam_role.main.arn
  
  alb_target_groups     = module.alb.services_target_group
}

module "cdn" {
  source = "./aws/modules/cdn"

  frontend_OAI          = aws_cloudfront_origin_access_identity.cdn
  frontend_origin_id    = "frontend"
  frontend_domain_name  = module.static_site.domain_name

  api_origin_id         = "api"
  api_domain_name       = module.alb.domain_name
  api_path_pattern      = "/api/*"

  aliases               = [var.app_domain, "*.${var.app_domain}"]
  certificate_arn       = module.certificate.arn

  alb_secret_header     = local.alb_cdn_secret_header
  alb_secret            = module.alb_cdn_secret.value
}

module "dns" {
  source = "./aws/modules/dns"

  app_domain  = var.app_domain
  cdn         = module.cdn.distribution
}


module "persistance" {
  source = "./aws/modules/persistance"
  
  vpc_id = module.vpc.vpc_id
  persistance_subnets =  module.vpc.privateDB_subnets_ids

 
}

