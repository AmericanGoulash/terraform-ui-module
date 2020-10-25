resource "aws_s3_bucket" "top_bucket" {
  bucket        = var.top_private_domain
  acl           = "private"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
    # Routing rules for normal paths to insert a prefix of # before the path.
    # For example: /login/callback -> /#/login/callback.
    # This allows for a single page application to use virtual routes while still
    # enabling functionality such as Cognito callback URLs (since Cognito doesn't
    # allow fragments, e.g. #, in the URL).
    routing_rules = templatefile(
      "${path.module}/bucket_routing_rules.json",
      { top_private_domain = var.top_private_domain }
    )
  }

  tags = merge(local.common_tags, var.common_tags, { Name = "s3_top_domain_bucket" })
}