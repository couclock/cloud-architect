# ----------------------------------------
# Installer les dépendances + compiler TS
# ----------------------------------------
resource "null_resource" "prepare_lambda" {
  provisioner "local-exec" {
    command = <<EOT
      set -e
      cd ${path.module}/files

      yarn install
      yarn build
    EOT
  }
  triggers = {
    checksum = filemd5("${path.module}/files/bedrock-lambda.ts")
  }
}

# ----------------------------------------
# Créer l'archive pour le layer
# ----------------------------------------
data "archive_file" "bedrock_layer_zip" {
  depends_on  = [null_resource.prepare_lambda]
  type        = "zip"
  source_dir  = "${path.module}/files/node_modules"
  output_path = "${path.module}/files/bedrock-layer.zip"
}

resource "aws_lambda_layer_version" "bedrock_sdk" {
  filename            = data.archive_file.bedrock_layer_zip.output_path
  layer_name          = "bedrock-sdk-layer"
  compatible_runtimes = ["nodejs24.x"]
  description         = "Layer with AWS SDK Bedrock client"
}

# ----------------------------------------
# Créer l'archive pour la Lambda
# ----------------------------------------
data "archive_file" "bedrock_lambda_zip" {
  depends_on  = [null_resource.prepare_lambda]
  type        = "zip"
  source_file = "${path.module}/files/dist/bedrock-lambda.js"
  output_path = "${path.module}/files/bedrock-lambda.zip"
}

# ----------------------------------------
# Déclarer la Lambda
# ----------------------------------------
resource "aws_lambda_function" "bedrock_lambda" {
  depends_on       = [aws_lambda_layer_version.bedrock_sdk]
  filename         = data.archive_file.bedrock_lambda_zip.output_path
  function_name    = "bedrock-lambda"
  description      = "Lambda to proxy Bedrock requests"
  role             = aws_iam_role.bedrock_lambda_role.arn
  handler          = "bedrock-lambda.handler"
  runtime          = "nodejs24.x"
  memory_size      = 256
  timeout          = 60
  publish          = true
  source_code_hash = data.archive_file.bedrock_lambda_zip.output_base64sha256

  layers = [
    aws_lambda_layer_version.bedrock_sdk.arn
  ]
}
