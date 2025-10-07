# Lambda Functions for API endpoints

# Create ZIP file for Lambda function
data "archive_file" "contact_form_zip" {
  type        = "zip"
  output_path = "${path.module}/contact_form.zip"
  source {
    content = file("${path.module}/contact_form.py")
    filename = "index.py"
  }
}

# Contact Form Handler
resource "aws_lambda_function" "contact_form" {
  filename         = "contact_form.zip"
  function_name    = "${var.project_name}-${var.environment}-contact-form"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  # source_code_hash = data.archive_file.contact_form_zip.output_base64sha256
  runtime         = "python3.9"
  timeout         = 30

  # environment {
  #   variables = {
  #     DYNAMODB_TABLE = var.dynamodb_table_name
  #   }
  # }

  tags = {
    Name        = "${var.project_name}-${var.environment}-contact-form"
    Environment = var.environment
  }
}


# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-${var.environment}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-lambda-role"
    Environment = var.environment
  }
}

# IAM Policy for Lambda
# resource "aws_iam_role_policy" "lambda_policy" {
#   name = "${var.project_name}-${var.environment}-lambda-policy"
#   role = aws_iam_role.lambda_role.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "logs:CreateLogGroup",
#           "logs:CreateLogStream",
#           "logs:PutLogEvents"
#         ]
#         Resource = "arn:aws:logs:*:*:*"
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "dynamodb:GetItem",
#           "dynamodb:PutItem",
#           "dynamodb:UpdateItem",
#           "dynamodb:Query",
#           "dynamodb:Scan"
#         ]
#         Resource = var.dynamodb_table_arn
#       }
#     ]
#   })
# }

# Attach basic execution role
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create ZIP files for Lambda functions
# data "archive_file" "contact_form_zip" {
#   type        = "zip"
#   output_path = "contact_form.zip"
#   source {
#     content = file("${path.module}/contact_form.py")
#     filename = "index.py"
#   }
# }

