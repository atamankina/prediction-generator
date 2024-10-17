output "prediction_generator_function_execution_role_arn" {
    description = "ARN of the lambda exectution role of the prediction generator function."
    value = module.prediction_function_execution_role.lambda_execution_role_arn
}

output "prediction_dynamodb_table_name" {
    description = "The name of the predictions DynamoDB table."
    value = module.prediction_table.dynamodb_table_name
}

output "api_url" {
  description = "URL of the API Gateway"
  value       = module.api_gateway.api_url
}