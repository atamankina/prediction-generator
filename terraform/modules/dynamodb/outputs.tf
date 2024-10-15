output "dynamodb_table_name" {
    description = "The name of the created DynamoDB table."
    value = aws_dynamodb_table.dynamodb_table.name
}