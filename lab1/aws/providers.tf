terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.71.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
  }
  required_version = "1.1.3"
}

provider "aws" {
  region     = var.aws_properties.region
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "tls" {}

provider "null" {}
