terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.62.0"
    }
  }
  backend "s3" {
  }
}

# AWS Provider Configuration - Region and Profile
provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}

# Get Current Partition (commercial or govcloud), Region and AWS Account ID
data "aws_partition" "current" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
