locals {
  # It should always be this value.
  # See: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-route53-aliastarget.html
  cloudfront_hosted_zone_id = "Z2FDTNDATAQYW2"

  common_tags = {
    CreatedBy = "terraform"
    Module    = "terraform-ui-module"
  }
}