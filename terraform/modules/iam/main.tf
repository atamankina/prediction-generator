resource "aws_iam_role" "lambda_execution_role" {
    name = var.role_name

    assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "lambda.amazonaws.com"
                ]
            }
        }
    ]
})
  
}

resource "aws_iam_role_policy_attachment" "lambda_execution_role_policy_attachment" {
    role = aws_iam_role.lambda_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/${var.policy_name}"
}

resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name        = "LambdaDynamoDBAccessPolicy"
  description = "Policy for Lambda to access DynamoDB"

  policy = jsonencode({
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": [
				"dynamodb:BatchGetItem",
				"dynamodb:BatchWriteItem",
				"dynamodb:PutItem",
				"dynamodb:DeleteItem",
				"dynamodb:GetItem",
				"dynamodb:Scan",
				"dynamodb:Query",
				"dynamodb:UpdateItem"
			],
			"Resource": "arn:aws:dynamodb:eu-central-1:273427624300:table/predictions"
		}
	]
})
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}