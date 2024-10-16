variable "api_name" {
  description = "The name of the API Gateway."
  type = string
}

variable "api_description" {
  description = "The description of the API Gateway."
  type = string
}

variable "api_path" {
    description = "The path to the API resource."
    type = string
}

variable "lambda_post_invoke_arn" {
    description = "The ARN of the lambda function processing the POST requests."
    type = string
}

variable "lambda_get_invoke_arn" {
    description = "The ARN of the lambda function processing the GET requests."
    type = string
}

variable "lambda_delete_invoke_arn" {
    description = "The ARN of the lambda function processing the DELETE requests."
    type = string
}

variable "api_stage_name" {
    description = "The deployment stage of the API."
    type = string
}

variable "lambda_post_function_name" {
    description = "The name of the lambda function processing the POST requests."
    type = string
}

variable "lambda_get_function_name" {
    description = "The name of the lambda function processing the GET requests."
    type = string
}

variable "lambda_delete_function_name" {
    description = "The name of the lambda function processing the DELETE requests."
    type = string
}