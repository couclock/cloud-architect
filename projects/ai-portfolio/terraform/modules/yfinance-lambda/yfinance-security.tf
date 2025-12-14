
### AWS Lambda function ###
# AWS Lambda API requires a ZIP file with the execution code
data "archive_file" "yfinance_security_zip" {
  type        = "zip"
  source_file = "${path.module}/files/yfinance-security-lambda.py"
  output_path = "${path.module}/files/yfinance-security-lambda.zip"
}

# Lambda defined that runs the Python code with the specified IAM role
resource "aws_lambda_function" "yfinance_security_lambda" {
  filename         = data.archive_file.yfinance_security_zip.output_path
  function_name    = "yfinance-security-lambda"
  description      = "Handle requests to Yahoo using yfinance lib"
  role             = var.lambda_logs_write_role_arn
  handler          = "yfinance-security-lambda.handler"
  runtime          = "python3.12"
  timeout          = 300
  memory_size      = 256
  publish          = true
  source_code_hash = data.archive_file.yfinance_security_zip.output_base64sha256
  layers = [
    aws_lambda_layer_version.yfinance_layer.arn,
    "arn:aws:lambda:eu-west-1:336392948345:layer:AWSSDKPandas-Python312:19" # AWS Provided layer
  ]
  depends_on = [aws_lambda_layer_version.yfinance_layer]
}
