variable "function_name" {
    description = "The name of the Lambda function."
    type = string
}

variable "lambda_role_arn" {
    description = "The ARN of the Lambda execution role"
    type = string
}

variable "handler" {
    description = "The function handler in the code"
    type = string
}

variable "runtime" {
    description = "The runtime for the Lmabda function"
    type = string
}

variable "lambda_zip_path" {
    description = "The path to the Lambda ZIP file"
    type = string
}

variable "lambda_environment_vars" {
    description = "Environment variables for the Lambda function"
    type = map(string)
}

variable "dynamodb_table_name" {
    description = "The name of the DynamoDB table to use"
    type = string
}