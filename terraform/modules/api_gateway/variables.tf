variable "api_name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "stage_name" {
  description = "The stage name of the API (e.g., dev, prod)"
  type        = string
}

variable "lambda_post_function_name" {
  description = "The name of the Lambda function to handle POST requests"
  type        = string
}

variable "lambda_get_function_name" {
  description = "The name of the Lambda function to handle GET requests"
  type        = string
}

variable "lambda_delete_function_name" {
  description = "The name of the Lambda function to handle DELETE requests"
  type        = string
}

variable "lambda_post_invoke_arn" {
  description = "The ARN of the Lambda function to handle POST requests"
  type        = string
}

variable "lambda_get_invoke_arn" {
  description = "The ARN of the Lambda function to handle GET requests"
  type        = string
}

variable "lambda_delete_invoke_arn" {
  description = "The ARN of the Lambda function to handle DELETE requests"
  type        = string
}