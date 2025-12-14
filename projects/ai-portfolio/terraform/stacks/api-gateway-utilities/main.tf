provider "aws" {
  region = "eu-west-1"
}

variable "my_domain" {
  type = string
}

data "terraform_remote_state" "yfinance_lambda" {
  backend = "s3"
  config = {
    bucket = "tf-states-cloud-arch-ai-portfolio"
    key    = "yfinance-lambda/terraform.tfstate"
    region = "eu-west-1"
  }
}

module "api_gateway_utilities" {
  source                       = "../../modules/api-gateway-utilities"
  my_domain                    = var.my_domain
  yfinance_security_lambda_arn = data.terraform_remote_state.yfinance_lambda.outputs.yfinance_security_lambda_arn
  yfinance_search_lambda_arn   = data.terraform_remote_state.yfinance_lambda.outputs.yfinance_search_lambda_arn
}
