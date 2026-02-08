
# ############################################
# Pour envoyer le site sur S3
# A faire apres la creation du bucket
# ############################################
# aws s3 sync ./dist s3://ai-portfolio.danylecoq.net

# ############################################
# Build frontend
# ############################################
resource "null_resource" "build_frontend" {
  provisioner "local-exec" {
    command = "cd ${path.module}/../../../frontend && yarn build"
  }

  triggers = {
    frontend_version = filemd5("${path.module}/../../../frontend/package.json")
  }
}

# ############################################
# Upload frontend to S3
# ############################################
resource "null_resource" "upload_frontend" {
  provisioner "local-exec" {
    command = "aws s3 sync ${path.module}/../../../frontend/dist s3://${aws_s3_bucket.frontend.id} --delete"
  }

  depends_on = [
    aws_s3_bucket.frontend,
    aws_s3_bucket_website_configuration.frontend,
    null_resource.build_frontend
  ]

  triggers = {
    frontend_version = filemd5("${path.module}/../../../frontend/package.json")
  }
}

# ############################################
# S3 subcket
# ############################################

resource "aws_s3_bucket" "frontend" {
  bucket        = "ai-portfolio.${var.my_domain}"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# ############################################
# S3 website hosting
# ############################################
resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}
# ############################################
# S3 policy
# ############################################
resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })
  depends_on = [
    aws_s3_bucket_public_access_block.frontend
  ]
}
