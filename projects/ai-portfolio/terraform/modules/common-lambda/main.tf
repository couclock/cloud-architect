
### IAM Role and Policy ###
# Allows Lambda function to describe, stop and start EC2 instances
resource "aws_iam_role" "lambda_logs_write_role" {
  name        = "lambda-logs-write-role"
  description = "Used by lambda functions to write logs on CloudWatch"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "logs_write_policy_document" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

resource "aws_iam_policy" "logs_write_policy" {
  name   = "logs-write-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.logs_write_policy_document.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs_write_role_attachment" {
  role       = aws_iam_role.lambda_logs_write_role.name
  policy_arn = aws_iam_policy.logs_write_policy.arn
}
