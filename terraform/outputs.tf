output "prediction_generator_function_arn" {
    description = "ARN of the prediction generator function."
    value = module.predition_generator_lambda.lambda_function_arn 
}

output "prediction_generator_function_execution_role_arn" {
    description = "ARN of the lambda exectution role of the prediction generator function."
    value = module.prediction_function_execution_role.lambda_execution_role_arn
}