terraform {
  required_version = "1.2.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.19.0"
    }

  }
  backend "s3" {}
}

provider "aws" {
  region = "eu-central-1"
  profile = "default"
}
