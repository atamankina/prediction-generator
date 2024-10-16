provider "aws" {
  region = "eu-central-1"
}

module "prediction_function_execution_role" {
    source = "./modules/iam"
    role_name = "prediction_generator_function_execution_role"
    policy_name = "AWSLambdaBasicExecutionRole"
    dynamodb_table_arn = module.prediction_table.dynamodb_table_arn
}

# Lambda for POST /prediction
module "post_prediction_lambda" {
  source              = "./modules/lambda"
  function_name       = "post-prediction-lambda"
  runtime             = "nodejs20.x"
  handler             = "prediction-functions/post.handler"
  lambda_role_arn     = module.prediction_function_execution_role.lambda_execution_role_arn
  lambda_zip_path     = "${path.module}/post-prediction-lambda.zip"
  dynamodb_table_name = module.prediction_table.dynamodb_table_name
  lambda_environment_vars    = {
    API_KEY = "test_value"
  }
}

# Lambda for GET /predictions
module "get_predictions_lambda" {
  source              = "./modules/lambda"
  function_name       = "get-predictions-lambda"
  runtime             = "nodejs20.x"
  handler             = "prediction-functions/get.handler"
  lambda_role_arn     = module.prediction_function_execution_role.lambda_execution_role_arn
  lambda_zip_path     = "${path.module}/get-predictions-lambda.zip"
  dynamodb_table_name = module.prediction_table.dynamodb_table_name
  lambda_environment_vars    = {
  }
}

# Lambda for DELETE /prediction/{id}
module "delete_prediction_lambda" {
  source              = "./modules/lambda"
  function_name       = "delete-prediction-lambda"
  runtime             = "nodejs20.x"
  handler             = "prediction-functions/delete.handler"
  lambda_role_arn     = module.prediction_function_execution_role.lambda_execution_role_arn
  lambda_zip_path     = "${path.module}/delete-prediction-lambda.zip"
  dynamodb_table_name = module.prediction_table.dynamodb_table_name
  lambda_environment_vars    = {
  }
}

module "prediction_table" {
  source        = "./modules/dynamodb"
  table_name    = "predictions"
  hash_key      = "predictionId"
}

module "api_gateway" {
  source                   = "./modules/api_gateway"
  api_name                 = "PredictionsAPI"
  stage_name               = "dev"
  lambda_post_function_name = module.post_prediction_lambda.lambda_function_name
  lambda_post_invoke_arn    = module.post_prediction_lambda.lambda_invoke_arn
  lambda_get_function_name  = module.get_predictions_lambda.lambda_function_name
  lambda_get_invoke_arn     = module.get_predictions_lambda.lambda_invoke_arn
  lambda_delete_function_name = module.delete_prediction_lambda.lambda_function_name
  lambda_delete_invoke_arn  = module.delete_prediction_lambda.lambda_invoke_arn
}


