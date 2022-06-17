locals {
  # Application names
  app_name                = "demo"
  pri_app_deploy          = "aws"
  sec_app_deploy          = "gcp"

  # Frontend
  static_resources        = "frontend"

  # SSH
  ssh_key_name            = "redes_key"

  # AWS VPC Configuration
  aws_vpc_network         = "10.0.0.0/16"
  aws_az_count            = 2

  # AWS EC2 configuration
  aws_ec2_ami             = "ami-0022f774911c1d690"
  aws_ec2_type            = "t2.micro"
  aws_ec2_web_user_data   = "scripts/web_server_user_data.sh"
}