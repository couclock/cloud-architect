provider "aws" {
  region = "eu-west-1"
}


data "terraform_remote_state" "common_lambda" {
  backend = "s3"
  config = {
    bucket = "tf-states-cloud-arch-ai-portfolio"
    key    = "common-lambda/terraform.tfstate"
    region = "eu-west-1"
  }
}


module "yfinance_lambda" {
  source                     = "../../modules/yfinance-lambda"
  lambda_logs_write_role_arn = data.terraform_remote_state.common_lambda.outputs.lambda_logs_write_role_arn
}
