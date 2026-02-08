resource "aws_iam_role" "bedrock_lambda_role" {
  name = "bedrock-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_logs" {
  name        = "lambda-basic-logs"
  description = "Allow Lambda to write CloudWatch logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "bedrock_invoke" {
  name        = "bedrock-invoke-model"
  description = "Allow invoking Bedrock models"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["bedrock:InvokeModel"]
        Resource = [
          "arn:aws:bedrock:eu-west-1::foundation-model/openai.gpt-oss-safeguard-20b",
          "arn:aws:bedrock:eu-west-1::foundation-model/openai.gpt-oss-20b-1:0",
          "arn:aws:bedrock:eu-west-1::foundation-model/openai.gpt-oss-120b-1:0",
          "arn:aws:bedrock:eu-west-1::foundation-model/openai.gpt-oss-safeguard-120b",
          "arn:aws:bedrock:eu-west-1::foundation-model/nvidia.nemotron-nano-9b-v2"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs_attach" {
  role       = aws_iam_role.bedrock_lambda_role.name
  policy_arn = aws_iam_policy.lambda_logs.arn
}

resource "aws_iam_role_policy_attachment" "bedrock_attach" {
  role       = aws_iam_role.bedrock_lambda_role.name
  policy_arn = aws_iam_policy.bedrock_invoke.arn
}
