provider "aws" {
  region = "eu-west-1"
}

module "common_lambda" {
  source = "../../modules/common-lambda"
}
module "yfinance_lambda" {
  source                     = "../../modules/yfinance-lambda"
  lambda_logs_write_role_arn = module.common_lambda.lambda_logs_write_role_arn
}
module "bedrock_lambda" {
  source                     = "../../modules/bedrock-lambda"
  lambda_logs_write_role_arn = module.common_lambda.lambda_logs_write_role_arn
}
