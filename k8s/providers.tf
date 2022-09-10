provider "aws" {
  region  = local.aws_region
  profile = "zilliqa-infra"
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args        = concat(["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name])
    env         = var.kubeconfig_aws_authenticator_env_variables
  }
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args        = concat(["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name])
    env         = var.kubeconfig_aws_authenticator_env_variables
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)

    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      command     = "aws"
      args        = concat(["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name])
      env         = var.kubeconfig_aws_authenticator_env_variables
    }
  }
}

variable "kubeconfig_aws_authenticator_env_variables" {
  type = map(string)

  default = {
    AWS_PROFILE = "zilliqa-infra"
  }
}