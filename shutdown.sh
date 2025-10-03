#!/bin/bash

# AWS Terraform Learning - Shutdown Script
# This script destroys all infrastructure to stop billing

echo "🛑 AWS Infrastructure Shutdown Script"
echo "======================================"
echo ""

# Check if we're in the right directory
if [ ! -f "main.tf" ]; then
    echo "❌ Error: Please run this script from the terraform project directory"
    exit 1
fi

# Check if terraform is initialized
if [ ! -d ".terraform" ]; then
    echo "❌ Error: Terraform not initialized. Run 'terraform init' first"
    exit 1
fi

echo "⚠️  WARNING: This will destroy ALL AWS infrastructure!"
echo "📊 Estimated monthly savings: ~$45 (mainly NAT Gateway)"
echo ""
read -p "Are you sure you want to continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Shutdown cancelled"
    exit 0
fi

echo ""
echo "🗑️  Destroying infrastructure..."
echo "This may take 5-10 minutes..."

# Destroy infrastructure
terraform destroy -auto-approve

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Infrastructure destroyed successfully!"
    echo "💰 Billing stopped for all resources"
    echo ""
    echo "📝 To restore infrastructure later:"
    echo "   1. Run: ./restart.sh"
    echo "   2. Or manually: terraform apply"
    echo ""
    echo "💡 Your terraform state is preserved locally"
else
    echo ""
    echo "❌ Error occurred during destruction"
    echo "💡 You may need to manually clean up some resources in AWS Console"
fi

echo ""
echo "🏁 Shutdown complete!"
