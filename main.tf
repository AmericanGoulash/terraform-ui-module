terraform {
  required_version = ">= 0.13"
}

provider "aws" {
  alias = "hosted_zone_account"
}