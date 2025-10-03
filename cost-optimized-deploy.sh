#!/bin/bash

# AWS Terraform Learning - Cost-Optimized Deployment
# This script deploys infrastructure with minimal costs (~$0-5/month)

echo "💰 AWS Cost-Optimized Deployment Script"
echo "======================================"
echo ""

# Check if we're in the right directory
if [ ! -f "main.tf" ]; then
    echo "❌ Error: Please run this script from the terraform project directory"
    exit 1
fi

echo "🔧 Switching to cost-optimized configuration..."
echo "💰 This removes NAT Gateway (saves ~$45/month)"
echo ""

# Backup current variables
if [ -f "variables.tf" ]; then
    cp variables.tf variables.tf.backup
    echo "📋 Backed up original variables.tf"
fi

# Use cost-optimized variables
cp variables-cost-optimized.tf variables.tf
echo "✅ Using cost-optimized configuration"

echo ""
echo "🔄 Initializing Terraform..."
terraform init

echo ""
echo "📋 Planning cost-optimized deployment..."
terraform plan

echo ""
echo "💰 Cost-Optimized Infrastructure:"
echo "   • S3 Bucket: FREE (within limits)"
echo "   • CloudFront: FREE (within limits)" 
echo "   • DynamoDB: FREE (within limits)"
echo "   • WAF: FREE (first 1M requests)"
echo "   • VPC: FREE"
echo "   • NO NAT Gateway: Saves ~$45/month"
echo ""
echo "⚠️  Note: Private subnets won't have internet access without NAT Gateway"
echo "💡 This is fine for a static website demo"
echo ""
read -p "Deploy cost-optimized infrastructure? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Deployment cancelled"
    # Restore original variables
    if [ -f "variables.tf.backup" ]; then
        mv variables.tf.backup variables.tf
        echo "🔄 Restored original variables.tf"
    fi
    exit 0
fi

echo ""
echo "🏗️  Deploying cost-optimized infrastructure..."
terraform apply -auto-approve

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Cost-optimized infrastructure deployed!"
    echo ""
    echo "🌐 Your website is available at:"
    terraform output cloudfront_url
    echo ""
    echo "💰 Estimated monthly cost: ~$0-5 (mostly free tier)"
    echo "🛑 To restore full infrastructure: ./restart.sh"
else
    echo ""
    echo "❌ Error occurred during deployment"
    # Restore original variables
    if [ -f "variables.tf.backup" ]; then
        mv variables.tf.backup variables.tf
        echo "🔄 Restored original variables.tf"
    fi
fi

echo ""
echo "🏁 Cost-optimized deployment complete!"
