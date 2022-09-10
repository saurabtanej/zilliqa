data "terraform_remote_state" "setup" {
  backend = "s3"
  config = {
    bucket  = "zilliqa-devops-dev-state"
    key     = "setup/terraform.tfstate"
    region  = "eu-west-1"
    profile = "dev-zilliqa-infra"
  }
}

# data "terraform_remote_state" "k8s" {
#   backend = "s3"
#   config = {
#     bucket  = "zilliqa-devops-dev-state"
#     key     = "k8s/terraform.tfstate"
#     region  = "eu-west-1"
#     profile = "dev-zilliqa-infra"
#   }
# }