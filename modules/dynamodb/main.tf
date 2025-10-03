# DynamoDB Module - Creates DynamoDB table for website data storage
# This module sets up DynamoDB with proper configuration for a website data store

# Create DynamoDB table for website data
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

  # Global Secondary Index for querying by category
  global_secondary_index {
    name     = "category-index"
    hash_key = "category"
    projection_type = "ALL"
  }

  # Point-in-time recovery
  point_in_time_recovery {
    enabled = true
  }

  # Server-side encryption
  server_side_encryption {
    enabled = true
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-website-data"
    Environment = var.environment
  }
}

# Create DynamoDB table for user sessions (optional)
resource "aws_dynamodb_table" "user_sessions" {
  name           = "${var.project_name}-${var.environment}-user-sessions"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "session_id"

  attribute {
    name = "session_id"
    type = "S"
  }

  attribute {
    name = "user_id"
    type = "S"
  }

  # Global Secondary Index for querying by user_id
  global_secondary_index {
    name     = "user-id-index"
    hash_key = "user_id"
    projection_type = "ALL"
  }

  # TTL for automatic cleanup of expired sessions
  ttl {
    attribute_name = "expires_at"
    enabled        = true
  }

  # Point-in-time recovery
  point_in_time_recovery {
    enabled = true
  }

  # Server-side encryption
  server_side_encryption {
    enabled = true
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-user-sessions"
    Environment = var.environment
  }
}
