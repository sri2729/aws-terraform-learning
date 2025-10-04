variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "contact_form_lambda_invoke_arn" {
  description = "Invoke ARN of the contact form Lambda function"
  type        = string
}

variable "contact_form_lambda_function_name" {
  description = "Name of the contact form Lambda function"
  type        = string
}
