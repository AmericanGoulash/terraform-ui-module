resource "aws_route53_record" "top_ipv4_record" {
  provider = aws.hosted_zone_account
  depends_on = [
    aws_cloudfront_distribution.top
  ]
  name    = var.top_private_domain
  zone_id = var.route53_zone_id
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.top.domain_name
    zone_id                = local.cloudfront_hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "top_ipv6_record" {
  provider = aws.hosted_zone_account
  depends_on = [
    aws_cloudfront_distribution.top
  ]
  name    = var.top_private_domain
  zone_id = var.route53_zone_id
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.top.domain_name
    zone_id                = local.cloudfront_hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www_ipv4_record" {
  provider = aws.hosted_zone_account
  depends_on = [
    aws_cloudfront_distribution.www
  ]
  name    = var.www_domain
  zone_id = var.route53_zone_id
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.www.domain_name
    zone_id                = local.cloudfront_hosted_zone_id
    evaluate_target_health = true
  }

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_route53_record" "www_ipv6_record" {
  provider = aws.hosted_zone_account
  depends_on = [
    aws_cloudfront_distribution.www
  ]
  name    = var.www_domain
  zone_id = var.route53_zone_id
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.www.domain_name
    zone_id                = local.cloudfront_hosted_zone_id
    evaluate_target_health = true
  }

  lifecycle {
    create_before_destroy = false
  }
}