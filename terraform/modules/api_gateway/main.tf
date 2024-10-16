resource "aws_api_gateway_rest_api" "rest_api" {
    name = var.api_name
    description = var.api_description
}

resource "aws_api_gateway_resource" "rest_api_resource" {
    rest_api_id = aws_api_gateway_rest_api.rest_api.id
    parent_id = aws_api_gateway_rest_api.rest_api.root_resource_id
    path_part = var.api_path
}

resource "aws_api_gateway_method" "post_method" {
    rest_api_id = aws_api_gateway_rest_api.rest_api.id
    resource_id = aws_api_gateway_resource.rest_api_resource.id
    http_method = "POST"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_integration" {
    rest_api_id = aws_api_gateway_rest_api.rest_api.id
    resource_id = aws_api_gateway_resource.rest_api_resource.id
    http_method = aws_api_gateway_method.post_method.id
    integration_http_method = "POST"
    type = "AWS_PROXY"
    uri = var.lambda_post_invoke_arn
}

resource "aws_api_gateway_method" "get_method" {
    rest_api_id = aws_api_gateway_rest_api.rest_api.id
    resource_id = aws_api_gateway_resource.rest_api_resource.id
    http_method = "GET"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_integration" {
    rest_api_id = aws_api_gateway_rest_api.rest_api.id
    resource_id = aws_api_gateway_resource.rest_api_resource.id
    http_method = aws_api_gateway_method.get_method.id
    integration_http_method = "GET"
    type = "AWS_PROXY"
    uri = var.lambda_get_invoke_arn
}

resource "aws_api_gateway_method" "delete_method" {
    rest_api_id = aws_api_gateway_rest_api.rest_api.id
    resource_id = aws_api_gateway_resource.rest_api_resource.id
    http_method = "DELETE"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "delete_integration" {
    rest_api_id = aws_api_gateway_rest_api.rest_api.id
    resource_id = aws_api_gateway_resource.rest_api_resource.id
    http_method = aws_api_gateway_method.delete_method.id
    integration_http_method = "DELETE"
    type = "AWS_PROXY"
    uri = var.lambda_delete_invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
    depends_on = [ 
        aws_api_gateway_integration.post_integration,
        aws_api_gateway_integration.get_integration,
        aws_api_gateway_integration.delete_integration
     ]
    
    rest_api_id = aws_api_gateway_rest_api.rest_api.id
    stage_name = var.api_stage_name
}

resource "aws_lambda_permission" "api_gateway_post_invoke_permission" {
    statement_id = "AllowAPIGatewayInvokePOST"
    action = "lambda:InvokeFunction"
    function_name = var.lambda_post_function_name
    principal = "apigateway.amazonaws.com"
    source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gateway_get_invoke_permission" {
    statement_id = "AllowAPIGatewayInvokeGET"
    action = "lambda:InvokeFunction"
    function_name = var.lambda_get_function_name
    principal = "apigateway.amazonaws.com"
    source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gateway_delete_invoke_permission" {
    statement_id = "AllowAPIGatewayInvokeDELETE"
    action = "lambda:InvokeFunction"
    function_name = var.lambda_delete_function_name
    principal = "apigateway.amazonaws.com"
    source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*"
}