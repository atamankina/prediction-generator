resource "aws_lambda_function" "lambda_function" {
    function_name = var.function_name
    role = var.lambda_role_arn
    handler = var.handler
    runtime = var.runtime

    filename = var.lambda_zip_path
    source_code_hash = filebase64sha256(var.lambda_zip_path)

    environment {
      variables = var.lambda_environment_vars
    }
}