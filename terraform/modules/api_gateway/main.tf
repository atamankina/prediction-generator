# Create the API Gateway REST API
resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_name
  description = "API for managing predictions."
}

# POST /prediction (Create Prediction)
resource "aws_api_gateway_resource" "post_prediction" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "prediction"
}

resource "aws_api_gateway_method" "post_prediction_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.post_prediction.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_prediction_integration" {
  rest_api_id            = aws_api_gateway_rest_api.api.id
  resource_id            = aws_api_gateway_resource.post_prediction.id
  http_method            = aws_api_gateway_method.post_prediction_method.http_method
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = var.lambda_post_invoke_arn
}

# GET /predictions (Get All Predictions)
resource "aws_api_gateway_resource" "get_predictions" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "predictions"
}

resource "aws_api_gateway_method" "get_predictions_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.get_predictions.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_predictions_integration" {
  rest_api_id            = aws_api_gateway_rest_api.api.id
  resource_id            = aws_api_gateway_resource.get_predictions.id
  http_method            = aws_api_gateway_method.get_predictions_method.http_method
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = var.lambda_get_invoke_arn
}

# DELETE /prediction/{id} (Delete Prediction by ID)
resource "aws_api_gateway_resource" "delete_prediction" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "prediction"
}

resource "aws_api_gateway_method" "delete_prediction_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.delete_prediction.id
  http_method   = "DELETE"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.predictionId" = true
  }
}

resource "aws_api_gateway_integration" "delete_prediction_integration" {
  rest_api_id            = aws_api_gateway_rest_api.api.id
  resource_id            = aws_api_gateway_resource.delete_prediction.id
  http_method            = aws_api_gateway_method.delete_prediction_method.http_method
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = var.lambda_delete_invoke_arn
}

# Deploy the API
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.post_prediction_integration,
    aws_api_gateway_integration.get_predictions_integration,
    aws_api_gateway_integration.delete_prediction_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = var.stage_name
}

# Lambda permissions for API Gateway to invoke the Lambda functions
resource "aws_lambda_permission" "api_gateway_post_invoke_permission" {
  statement_id  = "AllowAPIGatewayInvokePOST"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_post_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gateway_get_invoke_permission" {
  statement_id  = "AllowAPIGatewayInvokeGET"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_get_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gateway_delete_invoke_permission" {
  statement_id  = "AllowAPIGatewayInvokeDELETE"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_delete_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}
