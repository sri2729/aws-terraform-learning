# DynamoDB Module Outputs

output "table_name" {
  description = "Name of the main DynamoDB table"
  value       = aws_dynamodb_table.website_data.name
}

output "table_arn" {
  description = "ARN of the main DynamoDB table"
  value       = aws_dynamodb_table.website_data.arn
}

output "table_id" {
  description = "ID of the main DynamoDB table"
  value       = aws_dynamodb_table.website_data.id
}

# output "sessions_table_name" {
#   description = "Name of the user sessions DynamoDB table"
#   value       = aws_dynamodb_table.user_sessions.name
# }

# output "sessions_table_arn" {
#   description = "ARN of the user sessions DynamoDB table"
#   value       = aws_dynamodb_table.user_sessions.arn
# }

# output "sessions_table_id" {
#   description = "ID of the user sessions DynamoDB table"
#   value       = aws_dynamodb_table.user_sessions.id
# }
