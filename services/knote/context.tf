module "this" {
  source  = "cloudposse/label/null"
  version = "0.24.1" # requires Terraform >= 0.13.0

  namespace   = "zilliqa"
  environment = local.env
  name        = local.secret_name
  tags        = local.common_tags
}