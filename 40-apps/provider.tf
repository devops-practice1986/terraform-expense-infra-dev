terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.28.0"
    }
  }

  backend "s3" {
    bucket         = "yellow-remote-state"
    key            = "expense-apps"
    region         = "us-east-1"
    dynamodb_table = "yellow-locking"
  }
}

provider "aws" {
  region = "us-east-1"
}
