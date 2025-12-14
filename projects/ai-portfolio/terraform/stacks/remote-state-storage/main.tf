provider "aws" {
  region = "eu-west-1"
}

resource "aws_kms_key" "mykey" {
  description = "KMS key to encrypt Terraform states"
}

# #################################################
# S3 bucket used to store state remotely
resource "aws_s3_bucket" "terraform_state_s3_bucket" {
  bucket = "tf-states-cloud-arch-ai-portfolio"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "Terraform State File Storage"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state_s3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# ###########################################################################
# DynmoDB table used to store lock to avoid conflict during infra update
resource "aws_dynamodb_table" "terraform_state_locking_dynamodb" {
  name           = "terraform-locks-cloud-architect"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform State File Locking"
  }
}

