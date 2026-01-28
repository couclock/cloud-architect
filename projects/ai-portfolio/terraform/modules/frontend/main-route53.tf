
# ############################################
# Route53 zone
# ############################################

data "aws_route53_zone" "my_route53" {
  name         = "${var.my_domain}."
  private_zone = false
}

# ############################################
# Route53 alias
# ############################################
resource "aws_route53_record" "frontend" {
  zone_id = data.aws_route53_zone.my_route53.zone_id
  name    = "ai-portfolio.${var.my_domain}"
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.frontend.website_domain
    zone_id                = aws_s3_bucket.frontend.hosted_zone_id
    evaluate_target_health = false
  }
}
