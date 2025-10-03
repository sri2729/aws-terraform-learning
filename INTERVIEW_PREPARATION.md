# 🎯 **Terraform & AWS Interview Preparation Guide**

## 📋 **Project Overview**

**Project Name**: AWS Static Website with Terraform Infrastructure  
**Purpose**: Learn Terraform with AWS by building a production-ready static website  
**Architecture**: Multi-tier, secure, scalable web infrastructure  

---

## 🏗️ **High-Level Architecture**

```
Internet → CloudFront (CDN) → S3 Bucket → Static Website Files
    ↓
WAF (Security) → Rate Limiting & Protection
    ↓
VPC (Network) → Public/Private Subnets
    ↓
DynamoDB (Database) → Contact Forms & Analytics
```

---

## 🎯 **What This Project Demonstrates**

### **Terraform Skills:**
- Infrastructure as Code (IaC)
- Module-based architecture
- Variable management
- State management
- Provider configuration

### **AWS Services:**
- **S3**: Static website hosting
- **CloudFront**: Global CDN
- **DynamoDB**: NoSQL database
- **WAF**: Web Application Firewall
- **VPC**: Virtual Private Cloud

### **Best Practices:**
- Security implementation
- Cost optimization
- Scalability planning
- Monitoring setup

---

## 📁 **Project Structure Explained**

```
aws-terraform-learning/
├── main.tf                    # Main configuration file
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
├── terraform.tfvars          # Variable values
├── modules/                   # Reusable components
│   ├── vpc/                   # Network infrastructure
│   ├── s3/                    # Storage for website
│   ├── cloudfront/            # CDN distribution
│   ├── dynamodb/              # Database tables
│   └── waf/                   # Security layer
└── static-website/            # Website files
    ├── index.html             # Main page
    ├── css/style.css          # Styling
    └── js/script.js           # Interactive features
```

---

## 🔧 **Step-by-Step Deployment Process**

### **Step 1: Project Setup**
```bash
# Create project directory
mkdir aws-terraform-learning
cd aws-terraform-learning

# Initialize Terraform
terraform init
```

**WHY**: `terraform init` downloads the AWS provider plugin and initializes the backend for state management.

### **Step 2: Configure Variables**
```bash
# Copy example variables
cp terraform.tfvars.example terraform.tfvars

# Edit variables
nano terraform.tfvars
```

**WHY**: Variables make the code reusable and configurable for different environments.

### **Step 3: Plan Infrastructure**
```bash
terraform plan
```

**WHY**: Shows what resources will be created without actually creating them (dry run).

### **Step 4: Deploy Infrastructure**
```bash
terraform apply
```

**WHY**: Creates all AWS resources defined in the configuration files.

### **Step 5: Upload Website Files**
```bash
aws s3 sync static-website/ s3://your-bucket-name/
```

**WHY**: Uploads HTML, CSS, and JS files to S3 for website hosting.

---

## 🏢 **AWS Services Deep Dive**

### **1. Amazon S3 (Simple Storage Service)**
**WHAT**: Object storage service for storing files  
**WHY**: Perfect for static websites (HTML, CSS, JS, images)  
**HOW**: Stores website files and serves them via HTTP/HTTPS  

**Key Features:**
- Static website hosting
- Versioning (backup old versions)
- Encryption at rest
- Lifecycle policies (auto-delete old versions)
- CORS configuration (allow web requests)

### **2. Amazon CloudFront**
**WHAT**: Global Content Delivery Network (CDN)  
**WHY**: Faster website loading worldwide  
**HOW**: Caches website content at edge locations globally  

**Key Features:**
- SSL/HTTPS termination
- Custom error pages
- Cache optimization
- Geographic distribution
- DDoS protection

### **3. Amazon DynamoDB**
**WHAT**: NoSQL database service  
**WHY**: Store contact form submissions and visitor analytics  
**HOW**: Tables store structured data (JSON-like documents)  

**Key Features:**
- Serverless (no server management)
- Auto-scaling
- Point-in-time recovery
- Global secondary indexes
- TTL (Time To Live) for automatic cleanup

### **4. AWS WAF (Web Application Firewall)**
**WHAT**: Security service that filters web traffic  
**WHY**: Protect website from attacks and abuse  
**HOW**: Rules-based filtering before traffic reaches your site  

**Key Features:**
- Rate limiting (prevent spam)
- IP blocking
- SQL injection protection
- XSS protection
- Custom rules

### **5. Amazon VPC (Virtual Private Cloud)**
**WHAT**: Isolated network environment  
**WHY**: Secure network foundation for AWS resources  
**HOW**: Creates private networks with subnets and routing  

**Key Features:**
- Public subnets (internet access)
- Private subnets (no direct internet)
- NAT Gateway (internet for private resources)
- Route tables (traffic routing)
- Internet Gateway (internet connection)

---

## 📝 **Terraform Code Breakdown**

### **main.tf - Main Configuration**

```terraform
# Provider Configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

**EXPLANATION:**
- `terraform {}` block: Specifies Terraform and provider requirements
- `required_version`: Ensures compatible Terraform version
- `required_providers`: Downloads AWS provider plugin
- `provider "aws"`: Configures AWS provider with region

**INTERVIEW ANSWER**: "I specify the Terraform version and AWS provider requirements to ensure consistent deployments across environments. The provider block configures the AWS region where resources will be created."

### **Module Calls**

```terraform
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
- `module`: Calls a reusable Terraform module
- `source`: Path to module directory
- Parameters: Pass variables to the module

**INTERVIEW ANSWER**: "I use modules to organize code into reusable components. The VPC module creates network infrastructure, S3 module handles storage, etc. This makes the code maintainable and follows DRY principles."

### **variables.tf - Input Variables**

```terraform
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-west-2"
}
```

**EXPLANATION:**
- `variable`: Defines input parameter
- `description`: Documents the variable purpose
- `type`: Data type (string, number, bool, list, map)
- `default`: Default value if not specified

**INTERVIEW ANSWER**: "Variables make my Terraform code flexible and reusable. I can deploy the same infrastructure in different regions by just changing the region variable."

### **outputs.tf - Output Values**

```terraform
output "cloudfront_url" {
  description = "CloudFront distribution URL"
  value       = module.cloudfront.distribution_domain_name
}
```

**EXPLANATION:**
- `output`: Exposes values after deployment
- `description`: Documents the output
- `value`: References module output

**INTERVIEW ANSWER**: "Outputs expose important information after deployment, like the website URL. This makes it easy to find resources created by Terraform."

---

## 🔧 **Module Deep Dive**

### **VPC Module (modules/vpc/main.tf)**

```terraform
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
- `resource`: Creates AWS resource
- `aws_vpc`: AWS VPC resource type
- `cidr_block`: IP address range for VPC
- `enable_dns_hostnames`: Allows DNS hostnames
- `tags`: Metadata for resource identification

**INTERVIEW ANSWER**: "I create a VPC with DNS support enabled. The CIDR block defines the IP range, and tags help identify resources in the AWS console."

### **S3 Module (modules/s3/main.tf)**

```terraform
resource "aws_s3_bucket" "website" {
  bucket = "${var.project_name}-${var.environment}-${random_string.bucket_suffix.result}"

  tags = {
    Name        = "${var.project_name}-${var.environment}-website"
    Environment = var.environment
  }
}

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
- `random_string`: Generates random suffix for unique bucket names
- `website_configuration`: Enables static website hosting
- `index_document`: Default page (index.html)
- `error_document`: Custom error page

**INTERVIEW ANSWER**: "I create an S3 bucket with a random suffix to ensure uniqueness. The website configuration enables static hosting with custom index and error pages."

### **CloudFront Module (modules/cloudfront/main.tf)**

```terraform
resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name              = var.s3_bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
    origin_id                = "S3-${var.s3_bucket_name}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

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
  }
}
```

**EXPLANATION:**
- `origin`: Defines where CloudFront gets content (S3 bucket)
- `origin_access_control`: Secure access to S3 bucket
- `enabled`: Distribution is active
- `default_cache_behavior`: How CloudFront serves content
- `viewer_protocol_policy`: Force HTTPS redirect
- `allowed_methods`: HTTP methods allowed
- `cached_methods`: Methods that are cached

**INTERVIEW ANSWER**: "CloudFront creates a global CDN that caches content at edge locations. I configure it to serve from S3, force HTTPS, and cache GET/HEAD requests for better performance."

---

## 🎯 **Interview Q&A Scenarios**

### **Q1: "Explain your Terraform project architecture"**

**A**: "I built a production-ready static website infrastructure using Terraform and AWS. The architecture includes:

1. **S3** for static website hosting (HTML, CSS, JS files)
2. **CloudFront** as a global CDN for fast content delivery
3. **WAF** for security and rate limiting
4. **DynamoDB** for storing contact form submissions and analytics
5. **VPC** with public/private subnets for network security

The project demonstrates Infrastructure as Code principles with modular Terraform configurations. Each service is organized into modules for reusability and maintainability."

### **Q2: "Why did you choose these specific AWS services?"**

**A**: "Each service serves a specific purpose:

- **S3**: Perfect for static websites - no server management, automatic scaling, cost-effective
- **CloudFront**: Provides global performance, SSL termination, and DDoS protection
- **DynamoDB**: Serverless NoSQL database ideal for contact forms and simple data storage
- **WAF**: Essential security layer to protect against common web attacks
- **VPC**: Network isolation and security best practices

This combination follows AWS Well-Architected Framework principles for security, performance, and cost optimization."

### **Q3: "How do you handle security in your infrastructure?"**

**A**: "I implement multiple security layers:

1. **WAF**: Rate limiting (2000 requests per IP), SQL injection protection, XSS filtering
2. **CloudFront**: SSL/HTTPS enforcement, DDoS protection
3. **S3**: Bucket policies restrict access to CloudFront only
4. **VPC**: Network isolation with public/private subnets
5. **DynamoDB**: Encryption at rest and in transit

The security is defense-in-depth, meaning if one layer fails, others provide protection."

### **Q4: "How would you scale this infrastructure?"**

**A**: "The infrastructure is already designed for scale:

1. **S3**: Automatically handles any amount of traffic
2. **CloudFront**: Global edge locations handle traffic spikes
3. **DynamoDB**: Auto-scaling based on demand
4. **WAF**: Scales automatically with CloudFront

For future scaling, I could add:
- Auto Scaling Groups for dynamic compute
- Application Load Balancer for multiple instances
- RDS for complex database needs
- Lambda functions for serverless compute"

### **Q5: "Explain your cost optimization strategies"**

**A**: "I implemented several cost optimization measures:

1. **Free Tier Usage**: S3, CloudFront, DynamoDB within free limits
2. **S3 Lifecycle Policies**: Automatically delete old versions after 30 days
3. **CloudFront Caching**: Reduces origin requests (lower S3 costs)
4. **DynamoDB On-Demand**: Pay only for actual usage
5. **Cost Management Scripts**: Easy infrastructure shutdown/restart

I also created cost-optimized versions that remove expensive components like NAT Gateway for development environments."

---

## 🚀 **Deployment Commands Reference**

### **Initial Deployment**
```bash
# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Deploy infrastructure
terraform apply

# Upload website files
aws s3 sync static-website/ s3://your-bucket-name/
```

### **Cost Management**
```bash
# Stop billing (destroy infrastructure)
./shutdown.sh

# Restart for interview
./restart.sh

# Deploy cost-optimized version
./cost-optimized-deploy.sh
```

### **Useful Commands**
```bash
# View current resources
terraform show

# Get outputs
terraform output

# Update website files
aws s3 sync static-website/ s3://your-bucket-name/ --delete

# Clear CloudFront cache
aws cloudfront create-invalidation --distribution-id YOUR_ID --paths "/*"
```

---

## 🎯 **Key Interview Points to Remember**

### **Terraform Concepts:**
1. **Infrastructure as Code**: Version control for infrastructure
2. **State Management**: Terraform tracks resource state
3. **Modules**: Reusable, organized code components
4. **Providers**: Plugins for different cloud platforms
5. **Variables**: Configurable parameters
6. **Outputs**: Expose important values

### **AWS Services Knowledge:**
1. **S3**: Object storage, static website hosting
2. **CloudFront**: Global CDN, performance optimization
3. **DynamoDB**: NoSQL database, serverless
4. **WAF**: Web security, traffic filtering
5. **VPC**: Network isolation, security

### **Best Practices:**
1. **Security**: Defense in depth, least privilege
2. **Cost**: Free tier usage, lifecycle policies
3. **Scalability**: Auto-scaling, global distribution
4. **Monitoring**: CloudWatch, logging
5. **Documentation**: Clear comments, README files

---

## 💡 **Pro Tips for Interview**

1. **Start with Architecture**: Always explain the high-level design first
2. **Use Business Language**: Connect technical decisions to business value
3. **Show Problem-Solving**: Explain why you chose specific solutions
4. **Demonstrate Learning**: Show you understand both benefits and limitations
5. **Be Honest**: If you don't know something, say so and explain how you'd find out

---

## 🎯 **Final Interview Preparation Checklist**

- [ ] Understand every AWS service in the project
- [ ] Know the purpose of each Terraform file
- [ ] Practice explaining the architecture flow
- [ ] Understand cost implications
- [ ] Know how to deploy and manage the infrastructure
- [ ] Be ready to discuss alternatives and improvements
- [ ] Have the website URL ready to demonstrate

**Remember**: You're not just showing code - you're demonstrating problem-solving skills, AWS knowledge, and infrastructure thinking. Focus on the business value and real-world applications!
