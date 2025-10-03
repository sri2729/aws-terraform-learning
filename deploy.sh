#!/bin/bash

# AWS Terraform Learning Project - Deployment Script
# This script deploys the complete infrastructure and uploads the static website

set -e  # Exit on any error

echo "🚀 Starting AWS Terraform Learning Project Deployment"
echo "=================================================="

# Check if AWS CLI is configured
if ! aws sts get-caller-identity > /dev/null 2>&1; then
    echo "❌ AWS CLI is not configured. Please run 'aws configure' first."
    exit 1
fi

echo "✅ AWS CLI is configured"

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform is not installed. Please install Terraform first."
    exit 1
fi

echo "✅ Terraform is installed"

# Initialize Terraform
echo "📦 Initializing Terraform..."
terraform init

# Create terraform.tfvars if it doesn't exist
if [ ! -f "terraform.tfvars" ]; then
    echo "📝 Creating terraform.tfvars from example..."
    cp terraform.tfvars.example terraform.tfvars
    echo "⚠️  Please review and customize terraform.tfvars before proceeding"
    echo "Press Enter to continue or Ctrl+C to cancel..."
    read
fi

# Plan the infrastructure
echo "📋 Planning infrastructure..."
terraform plan -out=tfplan

echo "⚠️  This will create AWS resources that may incur costs."
echo "Press Enter to continue with deployment or Ctrl+C to cancel..."
read

# Apply the infrastructure
echo "🏗️  Deploying infrastructure..."
terraform apply tfplan

# Get the S3 bucket name from Terraform output
BUCKET_NAME=$(terraform output -raw s3_bucket_id)
echo "📦 S3 Bucket: $BUCKET_NAME"

# Upload static website files to S3
echo "📤 Uploading static website files to S3..."
aws s3 sync static-website/ s3://$BUCKET_NAME/ --delete

# Set proper content types
echo "🔧 Setting content types..."
aws s3 cp s3://$BUCKET_NAME/index.html s3://$BUCKET_NAME/index.html --content-type "text/html" --metadata-directive REPLACE
aws s3 cp s3://$BUCKET_NAME/error.html s3://$BUCKET_NAME/error.html --content-type "text/html" --metadata-directive REPLACE

# Set content types for CSS and JS files
aws s3 cp s3://$BUCKET_NAME/css/ s3://$BUCKET_NAME/css/ --recursive --content-type "text/css" --metadata-directive REPLACE
aws s3 cp s3://$BUCKET_NAME/js/ s3://$BUCKet_NAME/js/ --recursive --content-type "application/javascript" --metadata-directive REPLACE

# Get CloudFront distribution URL
CLOUDFRONT_URL=$(terraform output -raw cloudfront_website_url)
echo "🌐 CloudFront URL: $CLOUDFRONT_URL"

echo ""
echo "🎉 Deployment completed successfully!"
echo "=================================================="
echo "📊 Infrastructure Summary:"
echo "  • VPC: $(terraform output -raw vpc_id)"
echo "  • S3 Bucket: $BUCKET_NAME"
echo "  • CloudFront: $(terraform output -raw cloudfront_domain_name)"
echo "  • DynamoDB: $(terraform output -raw dynamodb_table_name)"
echo "  • WAF: $(terraform output -raw waf_web_acl_id)"
echo ""
echo "🌐 Website URL: $CLOUDFRONT_URL"
echo ""
echo "📚 Next Steps:"
echo "  1. Visit the website URL to see your static site"
echo "  2. Check AWS Console to explore the created resources"
echo "  3. Review the Terraform code to understand the infrastructure"
echo "  4. Run 'terraform destroy' when you're done to clean up resources"
echo ""
echo "Happy Learning! 🚀"
