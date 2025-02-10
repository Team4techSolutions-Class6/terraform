terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"
    }
  }
}


provider "aws" {
  region = "eu-west-2"
}

# VPC Module
module "vpc" {
  source               = "github.com/Team4techSolutions-Class6/modules//vpc"
  vpc_name             = "Test"
  cidr_block           = "10.25.0.0/16"
  public_subnet_cidr    = "10.25.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true
  availability_zone    = "eu-west-2a"
}

# EC2 Module (Jenkins Instance)
module "ec2_instance" {
  source        = "github.com/Team4techSolutions-Class6/modules//ec2"
  ami_id        = "ami-01ec84b284795cbc7"
  instance_type = "t2.micro"
  instance_name = "Jenkins"
  subnet_id     = module.vpc.public_subnet_id
  key_name      = "class6devops"
}
