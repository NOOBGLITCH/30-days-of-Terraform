terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      Project     = "Terraform-Full-Course-AWS"
      Day         = "10"
      Topic       = "Dynamic-Conditional-Splat"
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  }
}
