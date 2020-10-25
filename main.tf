terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      version = ">= 3.11.0"
      source  = "hashicorp/aws"
    }
  }
}