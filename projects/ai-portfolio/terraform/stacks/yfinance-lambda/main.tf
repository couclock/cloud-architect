provider "aws" {
  region = "eu-west-1"
}


data "terraform_remote_state" "common_lambda" {
  backend = "local"
  config = {
    path = "../common-lambda/terraform.tfstate"
  }
}


module "yfinance_lambda" {
  source                     = "../../modules/yfinance-lambda"
  lambda_logs_write_role_arn = data.terraform_remote_state.common_lambda.outputs.lambda_logs_write_role_arn
}
