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
      Day         = "08"
      Topic       = "Meta-Arguments"
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  }
}

# Alternate (alias) provider configuration in a different region.
# Used by the `provider` meta-argument below.
provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}
