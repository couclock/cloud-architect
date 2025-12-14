terraform {
  backend "s3" {
    bucket         = "tf-states-cloud-arch-ai-portfolio"
    key            = "common-lambda/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks-cloud-architect"
    encrypt        = true
  }
}
