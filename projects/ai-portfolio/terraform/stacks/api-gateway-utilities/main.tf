provider "aws" {
  region = "eu-west-1"
}

variable "my_domain" {
  type = string
}

data "terraform_remote_state" "lambda" {
  backend = "local"
  config = {
    path = "../lambda/terraform.tfstate"
  }
}

module "api_gateway_utilities" {
  source                       = "../../modules/api-gateway-utilities"
  my_domain                    = var.my_domain
  yfinance_security_lambda_arn = data.terraform_remote_state.lambda.outputs.yfinance_security_lambda_arn
  yfinance_search_lambda_arn   = data.terraform_remote_state.lambda.outputs.yfinance_search_lambda_arn
  bedrock_lambda_arn           = data.terraform_remote_state.lambda.outputs.bedrock_lambda_arn
}
