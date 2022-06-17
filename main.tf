terraform {
  required_version = "~> 1.2.0"

  backend "s3" {
    key     = "state"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
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

resource "aws_key_pair" "all_ec2" {
  key_name   = "all_ec2"
  public_key = file(var.ssh_key_path)
}

module "bastion" {
    source = "./aws/modules/bastion"

    vpc_id        = module.vpc.vpc_id
    subnets       = module.vpc.public_subnets_ids
    key_name      = aws_key_pair.all_ec2.id
    ami           = local.aws_ec2_ami
    my_ips        = var.my_ips
    instance_type = local.aws_ec2_type
}

data "template_file" "web_server_ud" {
  template = file(local.aws_ec2_web_user_data)
}

module "web_server" {
    source = "./aws/modules/web_server"

    vpc_id          = module.vpc.vpc_id
    vpc_cidr        = module.vpc.vpc_cidr
    private_subnets = module.vpc.private_subnets_ids
    public_subnets  = module.vpc.public_subnets_ids
    user_data       = data.template_file.web_server_ud.rendered
    key_name        = aws_key_pair.all_ec2.id
    ami             = local.aws_ec2_ami
    my_ips          = var.my_ips
    instance_type   = local.aws_ec2_type
}

resource "aws_cloudfront_origin_access_identity" "cdn" {
  comment = "Origin access for CDN to the frontend"
}

module "static_site" {
  source = "./aws/modules/static_site"

  src               = local.static_resources
  bucket_access_OAI = [aws_cloudfront_origin_access_identity.cdn.iam_arn]
}

module "cdn" {
  source = "./aws/modules/cdn"

  OAI                   = aws_cloudfront_origin_access_identity.cdn
  s3_origin_id          = "frontend"
  api_origin_id         = "nginx-api"
  api_domain_name       = module.web_server.domain_name
  bucket_domain_name    = module.static_site.domain_name
  aliases               = [var.app_domain, "*.${var.app_domain}"]
  certificate_arn       = module.certificate.arn
}

module "dns" {
  source = "./aws/modules/dns"

  app_domain = var.app_domain
  cdn         = module.cdn.distribution
}

