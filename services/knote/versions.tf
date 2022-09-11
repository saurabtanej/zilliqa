terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.75"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 1.3"
    }
  }
  required_version = ">= 0.13"
}