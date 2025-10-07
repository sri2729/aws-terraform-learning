# CloudFront Module Variables

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the website (optional)"
  type        = string
  default     = ""
}

variable "s3_bucket_id" {
  description = "ID of the S3 bucket"
  type        = string
}

variable "s3_bucket_domain" {
  description = "Domain name of the S3 bucket"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  type        = string
}

variable "waf_web_acl_id" {
  description = "ID of the WAF Web ACL"
  type        = string
}
