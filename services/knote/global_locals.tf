provider "aws" {
  alias   = "us-east"
  region  = "us-east-1"
  profile = "zilliqa-infra"
}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "zones" {
  state = "available"
}

locals {

  aws_region         = "eu-west-1"
  env                = "dev"
  account_id         = data.aws_caller_identity.current.account_id
  vpc_cidr           = "10.10.0.0/16"
  private_subnets    = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets     = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
  database_subnets   = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]
  availability_zones = data.aws_availability_zones.zones.names

  common_tags = {
    Terraform   = "true"
    CreatedBy   = "Terraform"
    Environment = "Dev"
  }

}
