# Create the API Gateway REST API
resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_name
  description = "API for managing predictions."
}

# POST /prediction (Create Prediction)
resource "aws_api_gateway_resource" "prediction_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "prediction"
}

resource "aws_api_gateway_method" "post_prediction_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.prediction_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_prediction_integration" {
  rest_api_id            = aws_api_gateway_rest_api.api.id
  resource_id            = aws_api_gateway_resource.prediction_resource.id
  http_method            = aws_api_gateway_method.post_prediction_method.http_method
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = var.lambda_post_invoke_arn
}

# POST /prediction (Create Prediction) method response with CORS
resource "aws_api_gateway_method_response" "post_prediction_method_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.prediction_resource.id
  http_method = aws_api_gateway_method.post_prediction_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

# POST /prediction (Create Prediction) integration response with CORS
resource "aws_api_gateway_integration_response" "post_prediction_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.prediction_resource.id
  http_method = aws_api_gateway_method.post_prediction_method.http_method
  status_code = "200"

  response_templates = {
    "application/json" = ""
  }
}

# GET /predictions (Get All Predictions)
resource "aws_api_gateway_method" "get_predictions_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.prediction_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_predictions_integration" {
  rest_api_id            = aws_api_gateway_rest_api.api.id
  resource_id            = aws_api_gateway_resource.prediction_resource.id
  http_method            = aws_api_gateway_method.get_predictions_method.http_method
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = var.lambda_get_invoke_arn
}

# GET /predictions (Get All Predictions) method response with CORS
resource "aws_api_gateway_method_response" "get_predictions_method_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.prediction_resource.id
  http_method = aws_api_gateway_method.get_predictions_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# GET /predictions (Get All Predictions) integration response with CORS
resource "aws_api_gateway_integration_response" "get_predictions_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.prediction_resource.id
  http_method = aws_api_gateway_method.get_predictions_method.http_method
  status_code = "200"

  response_templates = {
    "application/json" = ""
  }
}

# DELETE /prediction/{id} (Delete Prediction by ID)

resource "aws_api_gateway_resource" "delete_prediction_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.prediction_resource.id
  path_part   = "{predictionId}"  # This ensures the predictionId is part of the path
}

resource "aws_api_gateway_method" "delete_prediction_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.delete_prediction_resource.id
  http_method   = "DELETE"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.predictionId" = true
  }
}

resource "aws_api_gateway_integration" "delete_prediction_integration" {
  rest_api_id            = aws_api_gateway_rest_api.api.id
  resource_id            = aws_api_gateway_resource.delete_prediction_resource.id
  http_method            = aws_api_gateway_method.delete_prediction_method.http_method
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = var.lambda_delete_invoke_arn
}

# DELETE /prediction/{id} (Delete Prediction by ID) method response with CORS
resource "aws_api_gateway_method_response" "delete_prediction_method_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.delete_prediction_resource.id
  http_method = aws_api_gateway_method.delete_prediction_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

# DELETE /prediction/{id} (Delete Prediction by ID) integration response with CORS
resource "aws_api_gateway_integration_response" "delete_prediction_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.delete_prediction_resource.id
  http_method = aws_api_gateway_method.delete_prediction_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,GET,POST,DELETE'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [aws_api_gateway_method_response.delete_prediction_options_response]
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

# POST and GET /prediction OPTIONS preflight
resource "aws_api_gateway_method" "prediction_options" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.prediction_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "prediction_options_integration" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.prediction_resource.id
  http_method   = aws_api_gateway_method.prediction_options.http_method
  type          = "MOCK"
  
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "prediction_options_response" {
    rest_api_id   = aws_api_gateway_rest_api.api.id
    resource_id   = aws_api_gateway_resource.prediction_resource.id
    http_method   = aws_api_gateway_method.prediction_options.http_method
    status_code   = "200"

    response_models = {
        "application/json" = "Empty"
    }

    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin"  = true
    }

    depends_on = [aws_api_gateway_method.prediction_options]
}



resource "aws_api_gateway_integration_response" "options_integration_response" {
    rest_api_id   = aws_api_gateway_rest_api.api.id
    resource_id   = aws_api_gateway_resource.prediction_resource.id
    http_method   = aws_api_gateway_method.prediction_options.http_method
    status_code   = aws_api_gateway_method_response.prediction_options_response.status_code

    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
        "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,GET,POST,DELETE'",
        "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    }

    response_templates = {
        "application/json" = ""
    }

    depends_on = [aws_api_gateway_method_response.prediction_options_response]
}

# DELETE /prediction/{id} OPTIONS preflight
resource "aws_api_gateway_method" "delete_prediction_options" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.delete_prediction_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "delete_prediction_options_integration" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.delete_prediction_resource.id
  http_method   = aws_api_gateway_method.delete_prediction_options.http_method
  type          = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "delete_prediction_options_response" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.delete_prediction_resource.id
  http_method   = aws_api_gateway_method.delete_prediction_options.http_method
  status_code   = "200"

  # Add missing response_models
  response_models = {
      "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "delete_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.delete_prediction_resource.id
  http_method = aws_api_gateway_method.delete_prediction_options.http_method
  status_code = aws_api_gateway_method_response.delete_prediction_options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,GET,POST,DELETE'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [aws_api_gateway_method_response.delete_prediction_options_response]
}