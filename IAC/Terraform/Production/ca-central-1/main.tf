terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"
    }
  }
}

# Provider for ca-central-1 (Jenkins Server)
provider "aws" {
  alias  = "ca"
  region = "ca-central-1"
}

# Provider for us-east-1 (Accepter VPC)
provider "aws" {
  alias  = "us"
  region = "us-east-1"
}

# Provider for eu-west-2 (Future Use)
provider "aws" {
  alias  = "eu"
  region = "eu-west-2"
}

# VPC Module
module "vpc" {
  source               = "../../modules/vpc"
  vpc_name             = "Test"
  cidr_block           = "10.0.0.0/16"
  public_subnet_cidr    = "10.0.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true
  availability_zone    = "ca-central-1b"
}

# EC2 Module (Jenkins Instance)
module "ec2_instance" {
  source        = "../../modules/ec2"
  ami_id        = "ami-0c9f6749650d5c0e3"
  instance_type = "t2.micro"
  instance_name = "Jenkins"
  subnet_id     = module.vpc.public_subnet_id
  key_name      = "handson"
}

# VPC Peering Module: ca-central-1 ↔ us-east-1
module "ca_to_us_peering" {
  source                        = "../../modules/vpc-peering"
  requester_vpc_id              = "vpc-0b7b4741142c5be38"        # ca-central-1 VPC ID
  accepter_vpc_id               = "vpc-07daac7e527f66267"        # us-east-1 VPC ID
  accepter_region               = "us-east-1"
  requester_cidr                = "10.0.0.0/16"
  accepter_cidr                 = "172.31.0.0/16"

  # Public & Private Route Tables
  requester_public_route_table_ids = ["rtb-0dbee7bef354ca7c7"]
  requester_private_route_table_ids = []

  accepter_public_route_table_ids  = ["rtb-02f2f753cb51ac15d"]
  accepter_private_route_table_ids = []

  enable_public_routes = true
  enable_private_routes = true

  providers = {
    aws.requester = aws.ca
    aws.accepter  = aws.us
  }
}

# VPC Peering Module: ca-central-1 ↔ eu-west-2
module "ca_to_eu_peering" {
  source                        = "../../modules/vpc-peering"
  requester_vpc_id              = "vpc-0b7b4741142c5be38"        # ca-central-1 VPC ID
  accepter_vpc_id               = "vpc-02896d1fab55eabb6"        # eu-west-2 VPC ID
  accepter_region               = "eu-west-2"
  requester_cidr                = "10.0.0.0/16"
  accepter_cidr                 = "10.25.0.0/16"

  # Public & Private Route Tables
  requester_public_route_table_ids = ["rtb-0dbee7bef354ca7c7"]
  requester_private_route_table_ids = []

  accepter_public_route_table_ids  = ["rtb-06e26e4fe8a3f4ed0"]
  accepter_private_route_table_ids = []

  enable_public_routes = true
  enable_private_routes = false  # Only update public routes for EU

  providers = {
    aws.requester = aws.ca
    aws.accepter  = aws.eu
  }
}
