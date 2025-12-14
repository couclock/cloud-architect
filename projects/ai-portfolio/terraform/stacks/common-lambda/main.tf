provider "aws" {
  region = "eu-west-1"
}


module "common_lambda" {
  source = "../../modules/common-lambda"
}
