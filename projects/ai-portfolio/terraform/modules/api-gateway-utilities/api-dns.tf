# ################################################################
# DNS related stuff

# Custom domain name# Récupérer le certificat ACM existant
data "aws_acm_certificate" "amazon_issued" {
  domain      = "*.${var.my_domain}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

# Custom Domain pour API Gateway v2 (HTTP API)
resource "aws_apigatewayv2_domain_name" "backend" {
  domain_name = "api.${var.my_domain}"

  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.amazon_issued.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

# Récupérer la zone Route53
data "aws_route53_zone" "my_route53" {
  name         = "${var.my_domain}."
  private_zone = false
}

# Alias Record pour le custom domain
resource "aws_route53_record" "backend" {
  zone_id = data.aws_route53_zone.my_route53.id
  name    = aws_apigatewayv2_domain_name.backend.domain_name
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.backend.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.backend.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = true
  }
}

