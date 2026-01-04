######################################
# 1️⃣ API Gateway HTTP v2
######################################

# Création de l'API HTTP
resource "aws_apigatewayv2_api" "utilities_api" {
  name          = "utilities-api"
  description   = "API utilities: yfinance proxy"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = [
      "http://localhost:3000",
      "https://ton-frontend.com"
    ]

    allow_methods = [
      "GET",
      "OPTIONS"
    ]

    allow_headers = [
      "content-type",
      "authorization",
      "x-amz-date",
      "x-api-key",
      "x-amz-security-token"
    ]

    expose_headers = [
      "content-length"
    ]

    max_age = 3600
  }
}

# Intégration Lambda
resource "aws_apigatewayv2_integration" "yfinance_security_lambda_integration" {
  api_id                 = aws_apigatewayv2_api.utilities_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.yfinance_security_lambda_arn
  payload_format_version = "2.0"
}
resource "aws_apigatewayv2_integration" "yfinance_search_lambda_integration" {
  api_id                 = aws_apigatewayv2_api.utilities_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.yfinance_search_lambda_arn
  payload_format_version = "2.0"
}
# Route GET /yfinance/{ticker}/{action}
resource "aws_apigatewayv2_route" "yfinance_get_route" {
  api_id    = aws_apigatewayv2_api.utilities_api.id
  route_key = "GET /yfinance/{ticker}/{action}"
  target    = "integrations/${aws_apigatewayv2_integration.yfinance_security_lambda_integration.id}"
}
# Route GET /yfinance/search
resource "aws_apigatewayv2_route" "yfinance_search_route" {
  api_id    = aws_apigatewayv2_api.utilities_api.id
  route_key = "GET /yfinance/search"
  target    = "integrations/${aws_apigatewayv2_integration.yfinance_search_lambda_integration.id}"
}

# Stage prod
resource "aws_apigatewayv2_stage" "utilities_prod_stage" {
  api_id      = aws_apigatewayv2_api.utilities_api.id
  name        = "prod"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.utilities_api_gw_logs.arn
    format = jsonencode({
      requestId               = "$context.requestId"
      ip                      = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      httpMethod              = "$context.httpMethod"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      protocol                = "$context.protocol"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      errorMessage            = "$context.error.message"
      errorResponseType       = "$context.error.responseType"
      authorizerError         = "$context.authorizer.error"
    })
  }

  default_route_settings {
    logging_level            = "INFO"
    data_trace_enabled       = true
    detailed_metrics_enabled = true
    # Necessaire pour que API Gateway ne retourn pas des 429 (Too Many request) parce que la lambda mets trop de temps à s'initialiser
    throttling_rate_limit  = 10 # RPS
    throttling_burst_limit = 10 # maximum simultané
  }
}

######################################
# 3️⃣ API Mapping sous /utilities
######################################

resource "aws_apigatewayv2_api_mapping" "utilities_mapping" {
  api_id          = aws_apigatewayv2_api.utilities_api.id
  domain_name     = aws_apigatewayv2_domain_name.backend.domain_name
  stage           = aws_apigatewayv2_stage.utilities_prod_stage.name
  api_mapping_key = "utilities" # => accessible via /utilities/xxx
}


######################################
# 4️⃣ Permissions Lambda pour API Gateway
######################################

resource "aws_lambda_permission" "yfinance_security_allow_apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.yfinance_security_lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.utilities_api.execution_arn}/*/*"
}
resource "aws_lambda_permission" "yfinance_search_allow_apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.yfinance_search_lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.utilities_api.execution_arn}/*/*"
}

# Log Group
resource "aws_cloudwatch_log_group" "utilities_api_gw_logs" {
  name              = "/aws/apigateway/utilities-api"
  retention_in_days = 14
}

