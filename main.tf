terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.97.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# --- VPC ---
module "vpc" {
  source = "./vpc"

  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

# --- S3 BUCKET ---
module "s3" {
  source            = "./s3"
  bucket_name       = "bucket"
  force_destroy     = true
  enable_versioning = true
}

# --- RDS DATABASE ---
module "rds" {
  source         = "./rds"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnet_ids
  bastion_sg_id  = module.bastion.bastion_sg_id
  db_name        = var.db_name
  db_username    = var.db_username
  db_password    = var.db_password
}

# --- EC2 INSTANCES ---
module "ec2" {
  source        = "./ec2"
  vpc_id        = module.vpc.vpc_id
  subnet_ids    = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
  bastion_sg_id = module.bastion.bastion_sg_id
  alb_sg_id     = module.alb.alb_sg_id
  amazon_linux_2023 = var.amazon_linux_2023
  private_instance_count = 1
  key_name      = "testing"
}

# --- EC2 BASTION HOST ---
module "bastion" {
  source        = "./bastion"
  vpc_id        = module.vpc.vpc_id
  subnet_ids    = module.vpc.public_subnet_ids
  rds_sg_id     = module.rds.rds_sg_id
  private_sg_id  = module.ec2.private_sg_id
  amazon_linux_2023 = var.amazon_linux_2023
  key_name      = "testing"
}

# --- APPLICATION LOAD BALANCER ---
module "alb" {
  source = "./alb"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
  target_ids = {
  private = module.ec2.instance_ids
  }
  private_sg_id  = module.ec2.private_sg_id
}
