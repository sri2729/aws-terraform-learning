output "contact_form_function_arn" {
  description = "ARN of the contact form Lambda function"
  value       = aws_lambda_function.contact_form.arn
}

output "contact_form_invoke_arn" {
  description = "Invoke ARN of the contact form Lambda function"
  value       = aws_lambda_function.contact_form.invoke_arn
}

output "contact_form_function_name" {
  description = "Name of the contact form Lambda function"
  value       = aws_lambda_function.contact_form.function_name
}
