locals {
  top_origin_id = "topOrigin"
  www_origin_id = "wwwOrigin"
}

data "aws_iam_policy_document" "top_cloudfront_distribution" {
  statement {
    actions = ["s3:Get*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.top_cloudfront_distribution.iam_arn]
    }
    resources = ["${aws_s3_bucket.top_bucket.arn}/*"]
  }
}

resource "aws_cloudfront_origin_access_identity" "top_cloudfront_distribution" {
  comment = "OAI for the top bucket"
}

resource "aws_s3_bucket_policy" "top_bucket_s3_bucket_policy" {
  bucket = aws_s3_bucket.top_bucket.id
  policy = data.aws_iam_policy_document.top_cloudfront_distribution.json
}

resource "aws_cloudfront_distribution" "top" {
  depends_on = [
    aws_cloudfront_origin_access_identity.top_cloudfront_distribution
  ]
  enabled             = true
  default_root_object = "index.html"
  is_ipv6_enabled     = true
  aliases             = [var.top_private_domain]

  custom_error_response {
    error_code            = 403
    response_page_path    = "/index.html"
    error_caching_min_ttl = 86400
    response_code         = 200
  }

  custom_error_response {
    error_code            = 404
    response_page_path    = "/index.html"
    error_caching_min_ttl = 86400
    response_code         = 200
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    target_origin_id       = local.top_origin_id
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  # Don't cache index.html as that will change at every deployment because it's sourcing a different JS file
  ordered_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    target_origin_id       = local.top_origin_id
    viewer_protocol_policy = "redirect-to-https"
    path_pattern           = "index.html"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    forwarded_values {
      query_string = true
      cookies {
        forward = "all" # TODO: forward only what's needed.
      }
    }
  }

  origin {
    origin_id   = local.top_origin_id
    domain_name = aws_s3_bucket.top_bucket.bucket_regional_domain_name
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.top_cloudfront_distribution.cloudfront_access_identity_path
    }
  }
  viewer_certificate {
    acm_certificate_arn      = var.wildcard_certificate_arn
    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method       = "sni-only"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = merge(local.common_tags, var.common_tags, { Name = "cloudfront_top_domain_distribution" })
}

resource "aws_cloudfront_distribution" "www" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = [var.www_domain]

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    target_origin_id       = local.www_origin_id
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }
  origin {
    origin_id   = local.www_origin_id
    domain_name = var.top_private_domain

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.wildcard_certificate_arn
    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method       = "sni-only"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = merge(local.common_tags, var.common_tags, { Name = "cloudfront_www_domain_distribution" })
}

resource "aws_route53_record" "top_ipv4_record" {
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