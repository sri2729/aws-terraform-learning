# 📝 **Complete Terraform Code Breakdown**

## 🎯 **File-by-File Analysis**

---

## 📄 **main.tf - Main Configuration File**

### **Purpose**: Orchestrates all modules and defines the overall infrastructure

```terraform
# Terraform and Provider Requirements
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

**EXPLANATION:**
- `terraform {}`: Terraform configuration block
- `required_version`: Ensures Terraform version 1.0 or higher
- `required_providers`: Specifies which plugins Terraform needs
- `source = "hashicorp/aws"`: Official AWS provider from HashiCorp
- `version = "~> 5.0"`: Uses AWS provider version 5.x (latest compatible)

**INTERVIEW ANSWER**: "I specify version constraints to ensure consistent deployments. The AWS provider plugin allows Terraform to create AWS resources."

```terraform
# AWS Provider Configuration
provider "aws" {
  region = var.aws_region
}
```

**EXPLANATION:**
- `provider "aws"`: Configures the AWS provider
- `region = var.aws_region`: Uses the region variable for flexibility

**INTERVIEW ANSWER**: "The provider block tells Terraform which AWS region to use. I use a variable so I can easily change regions without modifying code."

### **Module Calls**

```terraform
# VPC Module - Network Infrastructure
module "vpc" {
  source = "./modules/vpc"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}
```

**EXPLANATION:**
- `module "vpc"`: Creates a VPC module instance
- `source`: Path to the module directory
- Parameters: Pass variables to the module

**INTERVIEW ANSWER**: "I call the VPC module to create network infrastructure. This includes the VPC, subnets, gateways, and routing tables."

```terraform
# S3 Module - Static Website Storage
module "s3" {
  source = "./modules/s3"
  
  project_name = var.project_name
  environment  = var.environment
  domain_name  = var.domain_name
}
```

**EXPLANATION:**
- Creates S3 bucket for website hosting
- Passes project name and environment for naming
- Domain name for bucket configuration

**INTERVIEW ANSWER**: "The S3 module creates a bucket for static website hosting. It configures website hosting, versioning, and encryption."

```terraform
# DynamoDB Module - Database Tables
module "dynamodb" {
  source = "./modules/dynamodb"
  
  project_name = var.project_name
  environment  = var.environment
}
```

**EXPLANATION:**
- Creates DynamoDB tables for data storage
- Used for contact forms and analytics

**INTERVIEW ANSWER**: "DynamoDB stores contact form submissions and visitor analytics. It's serverless and scales automatically."

```terraform
# WAF Module - Security Protection
module "waf" {
  source = "./modules/waf"
  
  project_name = var.project_name
  environment  = var.environment
}
```

**EXPLANATION:**
- Creates Web Application Firewall
- Protects against common attacks
- Rate limiting and filtering

**INTERVIEW ANSWER**: "WAF provides security by filtering malicious traffic and implementing rate limiting to prevent abuse."

```terraform
# CloudFront Module - Global CDN
module "cloudfront" {
  source = "./modules/cloudfront"
  
  project_name                = var.project_name
  environment                 = var.environment
  s3_bucket_name             = module.s3.bucket_name
  s3_bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  s3_bucket_arn              = module.s3.bucket_arn
  waf_web_acl_arn            = module.waf.web_acl_arn
  domain_name                = var.domain_name
}
```

**EXPLANATION:**
- Creates CloudFront distribution
- References S3 bucket and WAF from other modules
- Configures global CDN with security

**INTERVIEW ANSWER**: "CloudFront creates a global CDN that caches content at edge locations worldwide. It integrates with S3 for content and WAF for security."

---

## 📄 **variables.tf - Input Variables**

### **Purpose**: Defines configurable parameters for the infrastructure

```terraform
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-west-2"
}
```

**EXPLANATION:**
- `variable`: Declares an input variable
- `description`: Documents the variable purpose
- `type = string`: Specifies data type
- `default`: Default value if not provided

**INTERVIEW ANSWER**: "Variables make my code reusable. I can deploy the same infrastructure in different regions by changing this variable."

```terraform
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "aws-terraform-learning"
}
```

**EXPLANATION:**
- Used for resource naming
- Ensures consistent naming across resources

**INTERVIEW ANSWER**: "The project name is used in resource names to identify resources belonging to this project."

```terraform
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
```

**EXPLANATION:**
- Separates different environments (dev, staging, prod)
- Used in resource naming and tagging

**INTERVIEW ANSWER**: "Environment variable allows me to deploy the same infrastructure for development, staging, and production."

```terraform
variable "domain_name" {
  description = "Domain name for the website (optional)"
  type        = string
  default     = ""
}
```

**EXPLANATION:**
- Optional custom domain
- Used for CloudFront aliases and SSL certificates

**INTERVIEW ANSWER**: "Domain name is optional. If provided, CloudFront will use it instead of the default CloudFront domain."

```terraform
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}
```

**EXPLANATION:**
- Defines IP address range for VPC
- CIDR notation: 10.0.0.0/16 = 10.0.0.0 to 10.0.255.255

**INTERVIEW ANSWER**: "VPC CIDR defines the IP address space for my network. 10.0.0.0/16 gives me 65,536 IP addresses."

```terraform
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
```

**EXPLANATION:**
- List of CIDR blocks for public subnets
- Public subnets have internet access
- Each /24 subnet has 256 IP addresses

**INTERVIEW ANSWER**: "Public subnets are where resources with internet access go, like NAT Gateways. I create multiple subnets for high availability."

```terraform
variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}
```

**EXPLANATION:**
- List of CIDR blocks for private subnets
- Private subnets have no direct internet access
- Used for databases and internal services

**INTERVIEW ANSWER**: "Private subnets are for resources that shouldn't have direct internet access, providing an extra security layer."

---

## 📄 **outputs.tf - Output Values**

### **Purpose**: Exposes important information after deployment

```terraform
output "cloudfront_url" {
  description = "CloudFront distribution URL"
  value       = module.cloudfront.distribution_domain_name
}
```

**EXPLANATION:**
- `output`: Declares an output value
- `description`: Documents the output
- `value`: References module output

**INTERVIEW ANSWER**: "Outputs expose the website URL after deployment. This makes it easy to find the CloudFront URL."

```terraform
output "s3_bucket_name" {
  description = "S3 bucket name for website hosting"
  value       = module.s3.bucket_name
}
```

**EXPLANATION:**
- Exposes S3 bucket name
- Useful for uploading files or debugging

**INTERVIEW ANSWER**: "I output the S3 bucket name so I know which bucket to upload website files to."

```terraform
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}
```

**EXPLANATION:**
- Exposes VPC ID
- Useful for connecting other resources

**INTERVIEW ANSWER**: "VPC ID is useful if I need to connect additional resources to the same network."

---

## 📁 **modules/vpc/main.tf - VPC Module**

### **Purpose**: Creates network infrastructure

```terraform
# VPC Resource
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
  }
}
```

**EXPLANATION:**
- `resource "aws_vpc"`: Creates AWS VPC
- `cidr_block`: IP address range for VPC
- `enable_dns_hostnames`: Allows EC2 instances to get DNS hostnames
- `enable_dns_support`: Enables DNS resolution within VPC
- `tags`: Metadata for resource identification

**INTERVIEW ANSWER**: "I create a VPC with DNS support enabled. Tags help identify resources in the AWS console and for cost tracking."

```terraform
# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-igw"
    Environment = var.environment
  }
}
```

**EXPLANATION:**
- `aws_internet_gateway`: Provides internet access to VPC
- `vpc_id`: Associates gateway with VPC
- Required for public subnets to access internet

**INTERVIEW ANSWER**: "Internet Gateway is the door to the internet for my VPC. It's required for public subnets to have internet access."

```terraform
# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-${count.index + 1}"
    Environment = var.environment
    Type        = "public"
  }
}
```

**EXPLANATION:**
- `count`: Creates multiple resources based on list length
- `vpc_id`: Associates subnet with VPC
- `cidr_block`: IP range for this subnet
- `availability_zone`: Places subnet in specific AZ
- `map_public_ip_on_launch`: Auto-assigns public IP to instances

**INTERVIEW ANSWER**: "I create public subnets in different availability zones for high availability. Resources in public subnets can have public IP addresses."

```terraform
# NAT Gateway
resource "aws_nat_gateway" "main" {
  count = length(var.public_subnet_cidrs)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name        = "${var.project_name}-${var.environment}-nat-${count.index + 1}"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.main]
}
```

**EXPLANATION:**
- `aws_nat_gateway`: Allows private subnets to access internet
- `allocation_id`: Elastic IP for NAT Gateway
- `subnet_id`: Places NAT Gateway in public subnet
- `depends_on`: Ensures Internet Gateway is created first

**INTERVIEW ANSWER**: "NAT Gateway allows private subnets to access the internet for updates while keeping them secure. It's expensive (~$45/month) but provides security."

---

## 📁 **modules/s3/main.tf - S3 Module**

### **Purpose**: Creates S3 bucket for static website hosting

```terraform
# Random String for Unique Bucket Names
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}
```

**EXPLANATION:**
- `random_string`: Generates random string
- `length = 8`: 8 characters long
- `special = false`: No special characters
- `upper = false`: Only lowercase

**INTERVIEW ANSWER**: "S3 bucket names must be globally unique. I generate a random suffix to ensure uniqueness across all AWS accounts."

```terraform
# S3 Bucket
resource "aws_s3_bucket" "website" {
  bucket = "${var.project_name}-${var.environment}-${random_string.bucket_suffix.result}"

  tags = {
    Name        = "${var.project_name}-${var.environment}-website"
    Environment = var.environment
  }
}
```

**EXPLANATION:**
- `aws_s3_bucket`: Creates S3 bucket
- `bucket`: Bucket name with random suffix
- Tags for identification

**INTERVIEW ANSWER**: "I create an S3 bucket with a unique name. The bucket will store the static website files."

```terraform
# S3 Bucket Website Configuration
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
```

**EXPLANATION:**
- `aws_s3_bucket_website_configuration`: Enables static website hosting
- `index_document`: Default page (index.html)
- `error_document`: Custom 404 error page

**INTERVIEW ANSWER**: "This enables static website hosting on S3. When someone visits the bucket URL, they'll see index.html, and errors will show error.html."

```terraform
# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id
  versioning_configuration {
    status = "Enabled"
  }
}
```

**EXPLANATION:**
- `aws_s3_bucket_versioning`: Enables versioning
- `status = "Enabled"`: Turns on versioning

**INTERVIEW ANSWER**: "Versioning keeps old versions of files. If I upload a new version of index.html, the old version is preserved. This provides backup and rollback capability."

```terraform
# S3 Bucket Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

**EXPLANATION:**
- `aws_s3_bucket_server_side_encryption_configuration`: Enables encryption
- `sse_algorithm = "AES256"`: Uses AES-256 encryption

**INTERVIEW ANSWER**: "I enable server-side encryption to protect data at rest. AES-256 is a strong encryption standard."

```terraform
# S3 Bucket CORS Configuration
resource "aws_s3_bucket_cors_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}
```

**EXPLANATION:**
- `aws_s3_bucket_cors_configuration`: Configures CORS
- `allowed_methods`: HTTP methods allowed
- `allowed_origins`: Domains that can access the bucket
- `max_age_seconds`: How long browsers cache CORS preflight

**INTERVIEW ANSWER**: "CORS allows web browsers to access S3 resources from different domains. This is needed for CloudFront to work properly."

```terraform
# S3 Bucket Lifecycle Configuration
resource "aws_s3_bucket_lifecycle_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    id     = "delete_old_versions"
    status = "Enabled"
    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}
```

**EXPLANATION:**
- `aws_s3_bucket_lifecycle_configuration`: Manages object lifecycle
- `noncurrent_version_expiration`: Deletes old versions after 30 days
- `filter {}`: Applies to all objects

**INTERVIEW ANSWER**: "Lifecycle policies automatically delete old versions after 30 days. This saves storage costs while keeping recent backups."

---

## 📁 **modules/dynamodb/main.tf - DynamoDB Module**

### **Purpose**: Creates database tables for data storage

```terraform
# Website Data Table
resource "aws_dynamodb_table" "website_data" {
  name           = "${var.project_name}-${var.environment}-website-data"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "category"
    type = "S"
  }

  global_secondary_index {
    name     = "category-index"
    hash_key = "category"
    projection_type = "ALL"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-website-data"
    Environment = var.environment
  }
}
```

**EXPLANATION:**
- `aws_dynamodb_table`: Creates DynamoDB table
- `billing_mode = "PAY_PER_REQUEST"`: Pay only for actual usage
- `hash_key`: Primary key for the table
- `attribute`: Defines table attributes
- `global_secondary_index`: Allows querying by category
- `point_in_time_recovery`: Enables backup and restore
- `server_side_encryption`: Encrypts data at rest
- `ttl`: Time-to-live for automatic deletion

**INTERVIEW ANSWER**: "I create a DynamoDB table for website data. It uses pay-per-request billing, has encryption, backups, and TTL for automatic cleanup. The global secondary index allows querying by category."

---

## 📁 **modules/waf/main.tf - WAF Module**

### **Purpose**: Creates Web Application Firewall for security

```terraform
# WAF Web ACL
resource "aws_wafv2_web_acl" "main" {
  name  = "${var.project_name}-${var.environment}-web-acl"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

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
```

**EXPLANATION:**
- `aws_wafv2_web_acl`: Creates WAF Web ACL
- `scope = "CLOUDFRONT"`: Protects CloudFront distributions
- `default_action`: Allows traffic by default
- `rule`: Defines security rules
- `rate_based_statement`: Rate limiting rule
- `limit = 2000`: 2000 requests per 5 minutes per IP
- `visibility_config`: Enables CloudWatch metrics

**INTERVIEW ANSWER**: "WAF protects my website with rate limiting. It blocks IPs that make more than 2000 requests in 5 minutes, preventing abuse and DDoS attacks."

---

## 📁 **modules/cloudfront/main.tf - CloudFront Module**

### **Purpose**: Creates global CDN for fast content delivery

```terraform
# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "${var.project_name}-${var.environment}-oac"
  description                       = "OAC for ${var.project_name}-${var.environment}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
```

**EXPLANATION:**
- `aws_cloudfront_origin_access_control`: Secure access to S3
- `origin_access_control_origin_type = "s3"`: For S3 origins
- `signing_behavior = "always"`: Always sign requests
- `signing_protocol = "sigv4"`: Uses AWS Signature Version 4

**INTERVIEW ANSWER**: "Origin Access Control provides secure access to S3. It ensures only CloudFront can access the S3 bucket, preventing direct access."

```terraform
# CloudFront Distribution
resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name              = var.s3_bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
    origin_id                = "S3-${var.s3_bucket_name}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = var.domain_name != "" ? [var.domain_name] : []

  default_cache_behavior {
    target_origin_id       = "S3-${var.s3_bucket_name}"
    viewer_protocol_policy = "redirect-to-https"
    
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-cloudfront"
    Environment = var.environment
  }
}
```

**EXPLANATION:**
- `origin`: Defines where CloudFront gets content (S3)
- `enabled = true`: Distribution is active
- `default_root_object = "index.html"`: Default page
- `aliases`: Custom domain names
- `viewer_protocol_policy = "redirect-to-https"`: Force HTTPS
- `allowed_methods`: HTTP methods allowed
- `cached_methods`: Methods that are cached
- `geo_restriction`: Geographic restrictions (none = worldwide)
- `viewer_certificate`: SSL certificate configuration

**INTERVIEW ANSWER**: "CloudFront creates a global CDN that caches content at edge locations worldwide. It forces HTTPS, caches GET/HEAD requests, and serves content from S3. The distribution is available globally with no geographic restrictions."

---

## 🎯 **Key Terraform Concepts Explained**

### **1. Resources**
- **What**: AWS services created by Terraform
- **Example**: `aws_s3_bucket`, `aws_vpc`
- **Why**: Infrastructure as Code

### **2. Modules**
- **What**: Reusable code components
- **Example**: VPC module, S3 module
- **Why**: Organization, reusability, maintainability

### **3. Variables**
- **What**: Input parameters
- **Example**: `var.project_name`, `var.environment`
- **Why**: Flexibility, reusability

### **4. Outputs**
- **What**: Exposed values after deployment
- **Example**: CloudFront URL, S3 bucket name
- **Why**: Information sharing, debugging

### **5. Providers**
- **What**: Plugins for different platforms
- **Example**: AWS provider, Azure provider
- **Why**: Platform abstraction

### **6. State**
- **What**: Tracks resource status
- **Example**: `terraform.tfstate`
- **Why**: Change tracking, dependency management

---

## 💡 **Interview Tips for Code Discussion**

1. **Start with the big picture**: "This is a complete static website infrastructure..."
2. **Explain the flow**: "User requests → CloudFront → S3 → Website files"
3. **Connect to business value**: "This provides global performance and security..."
4. **Show understanding of alternatives**: "I chose S3 over EC2 because..."
5. **Demonstrate problem-solving**: "I added WAF because static sites need protection..."

**Remember**: You're not just explaining code - you're showing infrastructure thinking, security awareness, and business understanding!
