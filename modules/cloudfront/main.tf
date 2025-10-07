# CloudFront Module - Creates CloudFront distribution for CDN and SSL termination
# This module sets up CloudFront with proper caching and security configuration

# Create CloudFront Origin Access Identity (OAI)
resource "aws_cloudfront_origin_access_identity" "s3_oai" {
  comment = "${var.project_name}-${var.environment}-s3-oai"
}

# Create CloudFront distribution
resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name = var.s3_bucket_domain
    origin_id   = "S3-${var.s3_bucket_id}"
    
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.s3_oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.project_name}-${var.environment}-distribution"
  default_root_object = "index.html"

  # Custom domain (if provided)
  aliases = var.domain_name != "" ? [var.domain_name] : []

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.s3_bucket_id}"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

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

  # # Cache behavior for static assets
  # ordered_cache_behavior {
  #   path_pattern           = "/static/*"
  #   allowed_methods        = ["GET", "HEAD", "OPTIONS"]
  #   cached_methods         = ["GET", "HEAD"]
  #   target_origin_id       = "S3-${var.s3_bucket_id}"
  #   compress               = true
  #   viewer_protocol_policy = "redirect-to-https"

  #   forwarded_values {
  #     query_string = false
  #     cookies {
  #       forward = "none"
  #     }
  #   }

  #   min_ttl     = 0
  #   default_ttl = 31536000  # 1 year
  #   max_ttl     = 31536000
  # }

  # # Cache behavior for images
  # ordered_cache_behavior {
  #   path_pattern           = "/images/*"
  #   allowed_methods        = ["GET", "HEAD", "OPTIONS"]
  #   cached_methods         = ["GET", "HEAD"]
  #   target_origin_id       = "S3-${var.s3_bucket_id}"
  #   compress               = true
  #   viewer_protocol_policy = "redirect-to-https"

  #   forwarded_values {
  #     query_string = false
  #     cookies {
  #       forward = "none"
  #     }
  #   }

  #   min_ttl     = 0
  #   default_ttl = 31536000  # 1 year
  #   max_ttl     = 31536000
  # }

  # # Cache behavior for CSS and JS
  # ordered_cache_behavior {
  #   path_pattern           = "*.css"
  #   allowed_methods        = ["GET", "HEAD", "OPTIONS"]
  #   cached_methods         = ["GET", "HEAD"]
  #   target_origin_id       = "S3-${var.s3_bucket_id}"
  #   compress               = true
  #   viewer_protocol_policy = "redirect-to-https"

  #   forwarded_values {
  #     query_string = false
  #     cookies {
  #       forward = "none"
  #     }
  #   }

  #   min_ttl     = 0
  #   default_ttl = 31536000  # 1 year
  #   max_ttl     = 31536000
  # }

  # ordered_cache_behavior {
  #   path_pattern           = "*.js"
  #   allowed_methods        = ["GET", "HEAD", "OPTIONS"]
  #   cached_methods         = ["GET", "HEAD"]
  #   target_origin_id       = "S3-${var.s3_bucket_id}"
  #   compress               = true
  #   viewer_protocol_policy = "redirect-to-https"

  #   forwarded_values {
  #     query_string = false
  #     cookies {
  #       forward = "none"
  #     }
  #   }

  #   min_ttl     = 0
  #   default_ttl = 31536000  # 1 year
  #   max_ttl     = 31536000
  # }

  # Error pages
  # custom_error_response {
  #   error_code         = 404
  #   response_code      = 200
  #   response_page_path = "/index.html"
  # }

  # custom_error_response {
  #   error_code         = 403
  #   response_code      = 200
  #   response_page_path = "/index.html"
  # }

  # WAF Web ACL (disabled due to CloudFront access issues - WAF exists and is functional)
  # web_acl_id = var.waf_web_acl_id

  # # Price class
  # price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # SSL certificate (if custom domain)
  # dynamic "viewer_certificate" {
  #   for_each = var.domain_name != "" ? [1] : []
  #   content {
  #     cloudfront_default_certificate = true
  #     minimum_protocol_version       = "TLSv1.2_2021"
  #   }
  # }

  # # Default SSL certificate for CloudFront domain
 viewer_certificate {
  cloudfront_default_certificate = true
 }

  tags = {
    Name        = "${var.project_name}-${var.environment}-distribution"
    Environment = var.environment
  }
}

# Create S3 bucket policy to allow CloudFront access
resource "aws_s3_bucket_policy" "cloudfront_access" {
  bucket = var.s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontOAI"
        Effect = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.s3_oai.iam_arn
        }
        Action   = "s3:GetObject"
        Resource = "${var.s3_bucket_arn}/*"
      }
    ]
  })
}
