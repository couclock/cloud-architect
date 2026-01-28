provider "aws" {
  region = "eu-west-1"
}

variable "my_domain" {
  type = string
}

module "frontend" {
  source    = "../../modules/frontend"
  my_domain = var.my_domain
}
