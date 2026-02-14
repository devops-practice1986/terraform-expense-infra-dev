terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.28.0"
    }
  }

  backend "s3" {
    bucket         = "yellow-remote-123"
    key            = "expense-rds-dev"
    region         = "us-east-1"
    dynamodb_table = "yellow-locking-123"
  }
}

provider "aws" {
  region = "us-east-1"
}
