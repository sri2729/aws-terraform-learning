# WAF Module - Creates WAF Web ACL for security and rate limiting
# This module sets up WAF with common security rules

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider for us-east-1 (required for CloudFront WAF)
provider "aws" {
  region = "us-east-1"
}

# Create WAF Web ACL
resource "aws_wafv2_web_acl" "main" {
  name  = "${var.project_name}-${var.environment}-web-acl"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  # Simple rate limiting rule
  rule {
    name     = "RateLimitRule"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitRule"
      sampled_requests_enabled   = true
    }
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-web-acl"
    Environment = var.environment
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-${var.environment}-web-acl"
    sampled_requests_enabled   = true
  }
}

# Create CloudWatch Log Group for WAF
resource "aws_cloudwatch_log_group" "waf" {
  name              = "/aws/wafv2/${var.project_name}-${var.environment}"
  retention_in_days = 30

  tags = {
    Name        = "${var.project_name}-${var.environment}-waf-logs"
    Environment = var.environment
  }
}

# WAF Logging Configuration (commented out due to ARN format issues)
# resource "aws_wafv2_web_acl_logging_configuration" "main" {
#   resource_arn            = aws_wafv2_web_acl.main.arn
#   log_destination_configs = ["${aws_cloudwatch_log_group.waf.arn}:*"]
# }
