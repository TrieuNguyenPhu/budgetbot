# =============================================================================
# Root Module - VPC, Data Sources, Random Resources
# =============================================================================

# ---- VPC Module ----

module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

# ---- Auto-detect Latest Amazon Linux 2023 AMI ----

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# ---- Auto-generate RDS Password ----

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%^&*()-_=+"
}

# ---- Random Suffix for Globally Unique S3 Bucket Name ----

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
