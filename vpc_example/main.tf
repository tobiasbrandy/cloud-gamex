provider "aws" {
  region = "us-east-1"
}

module "vpc" {
    source = "../aws/modules/vpc"

    cidr_block = "10.0.0.0/16"
    zones_count = 3
}
