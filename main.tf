# AWS Terraform Learning Project - Main Configuration
# This file defines the provider and calls all our modules

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


# Data sources for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
  
  project_name     = var.project_name
  environment      = var.environment
  vpc_cidr         = var.vpc_cidr
  availability_zones = data.aws_availability_zones.available.names
}

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
  
  project_name     = var.project_name
  environment      = var.environment
  domain_name      = var.domain_name
  s3_bucket_id     = module.s3.bucket_id
  s3_bucket_domain = module.s3.bucket_domain_name
  s3_bucket_arn    = module.s3.bucket_arn
  waf_web_acl_arn  = module.waf.web_acl_arn
}
