variable "my_domain" {
  description = "Domain to use to create an API subdomain"
  type        = string
}

variable "yfinance_security_lambda_arn" {
  description = "yFinance lambda arn"
  type        = string
}
variable "yfinance_search_lambda_arn" {
  description = "yFinance search lambda arn"
  type        = string
}
