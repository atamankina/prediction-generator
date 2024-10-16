output "lambda_function_arn" {
    description = "The ARN of the Lambda function"
    value = aws_lambda_function.lambda_function.arn
}

# Output the Lambda function name
output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.lambda_function.function_name
}

# Output the Lambda function invoke ARN
output "lambda_invoke_arn" {
  description = "The invoke ARN of the Lambda function"
  value       = aws_lambda_function.lambda_function.invoke_arn
}
