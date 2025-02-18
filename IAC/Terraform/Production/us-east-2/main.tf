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
  region = "us-east-2"
}

module "vpc" {
  source               = "github.com/Team4techSolutions-Class6/modules//vpc"
  vpc_name             = "Test"
  cidr_block           = "172.24.0.0/16"
  public_subnet_cidr    = "172.24.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true
  availability_zone = "us-east-2b"
}

module "ec2_instance" {
  source        = "github.com/Team4techSolutions-Class6/modules//ec2"
  ami_id        = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  instance_name = "Jenkins"
  subnet_id     = module.vpc.public_subnet_id 
  key_name      = "team4techsolutions2"  
}



