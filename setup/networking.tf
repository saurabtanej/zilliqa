module "vpc" {
  source = "./.terraform/modules/aws-vpc"

  name = "zilliqa-${local.env}-vpc"

  cidr = local.vpc_cidr

  azs              = local.availability_zones
  private_subnets  = local.private_subnets
  public_subnets   = local.public_subnets
  database_subnets = local.database_subnets

  create_database_subnet_route_table = true

  single_nat_gateway = true
  enable_nat_gateway = true

  tags = local.common_tags
}