terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.27.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.5.1"
    }
    utils = {
      source  = "cloudposse/utils"
      version = ">= 0.12.0"
    }
  }
  required_version = ">= 0.13"
}