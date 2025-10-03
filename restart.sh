#!/bin/bash

# AWS Terraform Learning - Restart Script
# This script quickly redeploys infrastructure for interviews

echo "🚀 AWS Infrastructure Restart Script"
echo "===================================="
echo ""

# Check if we're in the right directory
if [ ! -f "main.tf" ]; then
    echo "❌ Error: Please run this script from the terraform project directory"
    exit 1
fi

echo "🔄 Initializing Terraform..."
terraform init

if [ $? -ne 0 ]; then
    echo "❌ Error: Terraform initialization failed"
    exit 1
fi

echo ""
echo "📋 Planning infrastructure deployment..."
terraform plan

echo ""
echo "⚠️  This will create AWS resources that may incur costs (~$45/month)"
echo "💰 Main cost: NAT Gateway (~$45/month)"
echo "🆓 Free tier: S3, CloudFront, DynamoDB (within limits)"
echo ""
read -p "Continue with deployment? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Deployment cancelled"
    exit 0
fi

echo ""
echo "🏗️  Deploying infrastructure..."
echo "This will take 10-15 minutes..."

# Deploy infrastructure
terraform apply -auto-approve

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Infrastructure deployed successfully!"
    echo ""
    echo "🌐 Your website is available at:"
    terraform output cloudfront_url
    echo ""
    echo "📊 Infrastructure Summary:"
    echo "   • S3 Bucket: Static website hosting"
    echo "   • CloudFront: Global CDN"
    echo "   • DynamoDB: Contact form & analytics storage"
    echo "   • WAF: Security protection"
    echo "   • VPC: Network infrastructure"
    echo ""
    echo "💰 Estimated monthly cost: ~$45 (mainly NAT Gateway)"
    echo "🛑 To stop billing: ./shutdown.sh"
else
    echo ""
    echo "❌ Error occurred during deployment"
    echo "💡 Check the error messages above and try again"
fi

echo ""
echo "🏁 Deployment complete!"
