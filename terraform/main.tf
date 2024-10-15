provider "aws" {
    region = "eu-central-1"
}

module "prediction_function_execution_role" {
    source = "./modules/iam"
    role_name = "prediction_generator_function_execution_role"
    policy_name = "AWSLambdaBasicExecutionRole"
}

module "predition_generator_lambda" {
    source = "./modules/lambda"
    function_name = "prediction_generator_function"
    runtime = "nodejs20.x"
    handler = "index.handler"
    lambda_role_arn = module.prediction_function_execution_role.lambda_execution_role_arn
    lambda_zip_path = "${path.module}/prediction-generator-lambda.zip"
    lambda_environment_vars = {
      API_TOKEN = "test_value"
    }  
}

module "prediction_dynamodb_table" {
    source = "./modules/dynamodb"
    table_name = "predictions"
    hash_key = "predictionId"
}

