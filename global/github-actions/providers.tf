terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.1"
    }
  }
}

provider "aws" {
  region  = "ap-southeast-1"
  profile = "aws-saas"

  default_tags {
    tags = {
      Environment = "DEV"
      ManagedBy   = "Terraform"
      Team        = "DevOps"
      Project     = "Viego"
    }
  }
}
