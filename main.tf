# AWS Terraform Learning Project - Main Configuration
# This file defines the provider and calls all our modules
#
# NOTE: VPC is DISABLED for cost optimization (~$45/month savings)
# - Static websites don't require VPC (S3, CloudFront, DynamoDB are global services)
# - VPC module is preserved for future use (EC2, RDS, containers)
# - To re-enable: uncomment the VPC module block below

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "aws-terraform-learning"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

# Configure AWS Provider for us-east-1 (required for WAF with CloudFront)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
  
  default_tags {
    tags = {
      Project     = "aws-terraform-learning"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}


# Data sources for availability zones
# NOTE: This is kept for potential future VPC use
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC Module - DISABLED FOR COST OPTIMIZATION
# Uncomment this block to re-enable VPC (adds ~$45/month for NAT Gateways)
# This is kept for future use when you need EC2, RDS, or other VPC-based services
# 
# module "vpc" {
#   source = "./modules/vpc"
#   
#   project_name     = var.project_name
#   environment      = var.environment
#   vpc_cidr         = var.vpc_cidr
#   availability_zones = data.aws_availability_zones.available.names
# }

# S3 Module for static website hosting
module "s3" {
  source = "./modules/s3"
  
  project_name = var.project_name
  environment  = var.environment
  domain_name  = var.domain_name
}

# DynamoDB Module
module "dynamodb" {
  source = "./modules/dynamodb"
  
  project_name = var.project_name
  environment  = var.environment
}

# WAF Module
module "waf" {
  source = "./modules/waf"
  
  providers = {
    aws = aws.us_east_1
  }
  
  project_name = var.project_name
  environment  = var.environment
}

# Lambda Functions Module
module "lambda" {
  source = "./modules/lambda"
  
  project_name         = var.project_name
  environment          = var.environment
  dynamodb_table_name  = module.dynamodb.table_name
  dynamodb_table_arn   = module.dynamodb.table_arn
}

# API Gateway Module
module "apigateway" {
  source = "./modules/apigateway"
  
  project_name                        = var.project_name
  environment                         = var.environment
  contact_form_lambda_invoke_arn      = module.lambda.contact_form_invoke_arn
  contact_form_lambda_function_name   = module.lambda.contact_form_function_name
}

# CloudFront Module
module "cloudfront" {
  source = "./modules/cloudfront"
  
  providers = {
    aws = aws.us_east_1
  }
  
  project_name     = var.project_name
  environment      = var.environment
  domain_name      = var.domain_name
  s3_bucket_id     = module.s3.bucket_id
  s3_bucket_domain = module.s3.bucket_domain_name
  s3_bucket_arn    = module.s3.bucket_arn
  waf_web_acl_id   = module.waf.web_acl_id
}
