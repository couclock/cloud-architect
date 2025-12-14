locals {
  yfinance_layer_zip_path = "${path.module}/yfinance-layer.zip"
  yfinance_layer_hash     = fileexists(local.yfinance_layer_zip_path) ? filebase64sha256(local.yfinance_layer_zip_path) : ""
}

# Étape 1 : construire le layer yfinance avec Docker
resource "null_resource" "build_yfinance_layer" {
  provisioner "local-exec" {
    command = <<EOT
      echo "Module dir: ${path.module}" && \
      docker run --rm -v ${path.module}:/out -w /out python:3.12-slim-bullseye bash -c "\
      apt-get update && apt-get install -y zip libffi-dev && \
      mkdir -p python && \
      pip install --upgrade pip && \
      pip install -r files/requirements.txt -t python/ && \
      rm -rf python/pandas python/numpy && \
      zip -r files/yfinance-layer.zip python && \
      rm -rf python"
    EOT
  }

  triggers = {
    layer_checksum = filemd5("${path.module}/files/requirements.txt")
  }
}

# Étape 2 : créer la Layer AWS à partir du ZIP généré
resource "aws_lambda_layer_version" "yfinance_layer" {
  filename            = "${path.module}/files/yfinance-layer.zip"
  layer_name          = "yfinance-layer"
  description         = "Layer including only yfinance (without pandas dependency)"
  compatible_runtimes = ["python3.12"]
  source_code_hash    = local.yfinance_layer_hash

  depends_on = [null_resource.build_yfinance_layer]
}
