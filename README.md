# 🚀 **AWS Terraform Learning Project**

[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://terraform.io)
[![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com)
[![Infrastructure as Code](https://img.shields.io/badge/Infrastructure%20as%20Code-FF6B6B?style=for-the-badge&logo=git&logoColor=white)](https://en.wikipedia.org/wiki/Infrastructure_as_code)

> **Production-ready AWS infrastructure built with Terraform for learning and demonstrating real-world DevOps skills.**

## 🌐 **Live Demo**

**🚀 [View Live Website](https://d3oiryuf0ls3m3.cloudfront.net)**

A fully functional static website with contact forms, visitor analytics, and professional UI demonstrating the deployed infrastructure.

---

## 📋 **Project Overview**

This project demonstrates **Infrastructure as Code** principles by building a complete AWS infrastructure using Terraform. It includes a production-ready static website with multiple AWS services working together to provide security, performance, and scalability.

### **🏗️ Architecture**

```
Internet → CloudFront (CDN) → WAF (Security) → S3 (Storage) → Website Files
                                    ↓
                              API Gateway → Lambda Functions → DynamoDB (Database)
                                    ↓
                              Contact Forms & Analytics ← Serverless Backend
```

### **📊 Infrastructure Stats**
- **40+ AWS Resources** deployed with Terraform
- **7 Core Services**: VPC, S3, CloudFront, DynamoDB, WAF, API Gateway, Lambda
- **Global CDN** with 200+ edge locations worldwide
- **Serverless Backend** with API Gateway and Lambda functions
- **Production-Ready** with security and monitoring
- **Cost-Optimized** using AWS Free Tier

---

## 🎯 **What This Project Demonstrates**

### **Terraform Skills**
- ✅ Infrastructure as Code (IaC)
- ✅ Modular architecture with reusable components
- ✅ Variable management and configuration
- ✅ State management and dependency handling
- ✅ Multi-region provider configuration

### **AWS Services**
- ✅ **Amazon S3**: Static website hosting with versioning and encryption
- ✅ **Amazon CloudFront**: Global CDN with SSL termination and caching
- ✅ **Amazon DynamoDB**: NoSQL database for contact forms and analytics
- ✅ **AWS WAF**: Web Application Firewall with rate limiting
- ✅ **Amazon VPC**: Network infrastructure with public/private subnets
- ✅ **Amazon API Gateway**: RESTful API management with CORS support
- ✅ **AWS Lambda**: Serverless compute functions for backend processing

### **Best Practices**
- ✅ Security implementation (defense in depth)
- ✅ Cost optimization strategies
- ✅ Scalability and performance considerations
- ✅ Monitoring and logging setup
- ✅ Documentation and code organization

---

## 🚀 **Quick Start**

### **Prerequisites**
- [Terraform](https://terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured
- AWS account with appropriate permissions

### **Deployment**

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/aws-terraform-learning.git
   cd aws-terraform-learning
   ```

2. **Configure variables**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

3. **Deploy infrastructure**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. **Upload website files**
   ```bash
   aws s3 sync static-website/ s3://your-bucket-name/
   aws cloudfront create-invalidation --distribution-id YOUR_DISTRIBUTION_ID --paths "/*"
   ```

### **Cost Management**
```bash
# Stop billing (destroy infrastructure)
terraform destroy

# Deploy infrastructure
terraform apply

# Plan changes before applying
terraform plan
```

---

## 📁 **Project Structure**

```
aws-terraform-learning/
├── 📄 main.tf                          # Main Terraform configuration
├── 📄 variables.tf                     # Input variables
├── 📄 outputs.tf                       # Output values
├── 📄 terraform.tfvars.example         # Example variable values
├── 📄 .gitignore                       # Git ignore rules
├── 📄 README.md                        # This file
├── 📄 INTERVIEW_PREPARATION.md         # Comprehensive interview guide
├── 📄 TERRAFORM_CODE_BREAKDOWN.md      # Line-by-line code explanations
├── 📄 INTERVIEW_QA_GUIDE.md           # 18 realistic interview scenarios
├── 📄 QUICK_REFERENCE.md              # Quick reference guide
└── 📁 modules/                        # Terraform modules
    ├── 📁 vpc/                        # Network infrastructure
    ├── 📁 s3/                         # Storage and website hosting
    ├── 📁 cloudfront/                 # CDN distribution
    ├── 📁 dynamodb/                   # Database tables
    ├── 📁 waf/                        # Security layer
    ├── 📁 apigateway/                 # REST API management
    └── 📁 lambda/                     # Serverless functions
└── 📁 static-website/                 # Website files
    ├── 📄 index.html                  # Main website
    ├── 📁 css/style.css               # Styling
    ├── 📁 js/script.js                # Interactive features
    └── 📄 error.html                  # Custom error page
```

---

## 💰 **Cost Breakdown**

| Service | Cost | Notes |
|---------|------|-------|
| **S3** | FREE | Within 5GB free tier |
| **CloudFront** | FREE | Within 1TB free tier |
| **DynamoDB** | FREE | Within 25GB free tier |
| **WAF** | FREE | Within 1M requests free tier |
| **VPC** | FREE | Always free |
| **API Gateway** | FREE | Within 1M requests free tier |
| **Lambda** | FREE | Within 1M requests + 400,000 GB-seconds free tier |
| **NAT Gateway** | ~$45/month | Main cost component |
| **Data Transfer** | ~$0.09/GB | Minimal for static sites |

**Total Estimated Cost**: ~$45/month (with NAT Gateway) or ~$0-5/month (without NAT Gateway)

---

## 🔒 **Security Features**

- **🛡️ WAF Protection**: Rate limiting (2000 requests/IP/5min), SQL injection protection
- **🔐 HTTPS Enforcement**: SSL termination at CloudFront
- **🔒 Data Encryption**: S3 and DynamoDB encryption at rest
- **🌐 Network Isolation**: VPC with public/private subnet separation
- **📊 Access Control**: S3 bucket policies restrict access to CloudFront only
- **🔄 Backup & Recovery**: Point-in-time recovery for DynamoDB, S3 versioning

---

## 📈 **Performance Features**

- **🌍 Global CDN**: 200+ CloudFront edge locations worldwide
- **⚡ Edge Caching**: Optimized cache behaviors for different content types
- **🔄 Auto-Scaling**: DynamoDB and S3 scale automatically with demand
- **📊 Monitoring**: CloudWatch metrics and logging
- **🚀 Fast Loading**: Optimized for Core Web Vitals
- **⚡ Serverless Backend**: API Gateway + Lambda for instant scaling
- **🔄 Event-Driven**: Lambda functions triggered by API requests

---

## ⚡ **Serverless Backend Features**

- **🔗 API Gateway**: RESTful API with CORS support for cross-origin requests
- **⚡ Lambda Functions**: Python-based serverless functions for contact form processing
- **📊 DynamoDB Integration**: Direct database access from Lambda functions
- **🔒 IAM Security**: Proper role-based access control for Lambda execution
- **📝 Contact Form Processing**: Automated form submission handling with validation
- **🔄 Auto-Scaling**: Serverless functions scale automatically with demand
- **💰 Cost-Effective**: Pay only for actual function execution time

---

## 🎯 **Learning Outcomes**

This project provides hands-on experience with:

1. **Infrastructure as Code**: Writing, testing, and managing infrastructure code
2. **AWS Services**: Deep understanding of core AWS services and their interactions
3. **Serverless Architecture**: API Gateway, Lambda functions, and event-driven computing
4. **Security Best Practices**: Implementing defense-in-depth security
5. **Cost Optimization**: Managing cloud costs effectively with serverless components
6. **DevOps Practices**: CI/CD, monitoring, and operational excellence
7. **Real-World Scenarios**: Production-ready infrastructure patterns

---

## 📚 **Documentation**

- **[Interview Preparation Guide](INTERVIEW_PREPARATION.md)** - Complete project overview and architecture
- **[Terraform Code Breakdown](TERRAFORM_CODE_BREAKDOWN.md)** - Line-by-line code explanations
- **[Interview Q&A Guide](INTERVIEW_QA_GUIDE.md)** - 18 realistic interview scenarios
- **[Quick Reference](QUICK_REFERENCE.md)** - One-page summary for interviews

---

## 🛠️ **Technologies Used**

| Technology | Purpose | Version |
|------------|---------|---------|
| **Terraform** | Infrastructure as Code | >= 1.0 |
| **AWS Provider** | Terraform AWS integration | ~> 5.0 |
| **Amazon S3** | Static website hosting | Latest |
| **Amazon CloudFront** | Global CDN | Latest |
| **Amazon DynamoDB** | NoSQL database | Latest |
| **AWS WAF** | Web Application Firewall | Latest |
| **Amazon VPC** | Network infrastructure | Latest |
| **Amazon API Gateway** | REST API management | Latest |
| **AWS Lambda** | Serverless compute | Latest |
| **HTML/CSS/JavaScript** | Frontend development | Modern standards |

---

## 🤝 **Contributing**

This is a learning project, but contributions are welcome! Please feel free to:

- 🐛 Report bugs or issues
- 💡 Suggest improvements or new features
- 📖 Improve documentation
- 🔧 Add new modules or services

---

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 **Author**

**Sri Shakthi**
- 📧 Email: shakthisri2729@gmail.com
- 💼 LinkedIn: [Your LinkedIn Profile]
- 🐙 GitHub: [Your GitHub Profile]

---

## 🙏 **Acknowledgments**

- AWS Free Tier for providing resources for learning
- Terraform community for excellent documentation
- HashiCorp for creating amazing Infrastructure as Code tools

---

## 📊 **Repository Stats**

![GitHub stars](https://img.shields.io/github/stars/yourusername/aws-terraform-learning?style=social)
![GitHub forks](https://img.shields.io/github/forks/yourusername/aws-terraform-learning?style=social)
![GitHub issues](https://img.shields.io/github/issues/yourusername/aws-terraform-learning)
![GitHub pull requests](https://img.shields.io/github/issues-pr/yourusername/aws-terraform-learning)

---

<div align="center">

**⭐ Star this repository if you found it helpful!**

Made with ❤️ for the DevOps community

</div>