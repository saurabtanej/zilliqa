locals {

  values = yamlencode({
    "awsRegion" : data.aws_region.current.name,
    "autoDiscovery" : {
      "clusterName" : local.eks_cluster_name
    },
    "rbac" : {
      "create" : "true",
      "serviceAccount" : {
        "create" : "true",
        "name" : "cluster-autoscaler"
        "annotations" : {
          "eks.amazonaws.com/role-arn" : module.cluster_autoscaler_irsa_role.iam_role_arn
        }
      }
    }
  })
  enable_cluster_autoscaler    = false
  cluster_autoscaler_namespace = "kube-system"
}

data "aws_region" "current" {}

data "utils_deep_merge_yaml" "values" {
  count = local.enable_cluster_autoscaler ? 1 : 0
  input = compact([
    local.values,
    local.cluster_autoscaler_values
  ])
}

module "cluster_autoscaler_irsa_role" {
  source = "./.terraform/modules/aws-eks-iam-role-sa"

  create_role = local.enable_cluster_autoscaler == true ? true : false

  role_name                        = "${local.eks_cluster_name}-cluster-autoscaler"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_ids   = [module.eks.cluster_id]

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${local.cluster_autoscaler_namespace}:cluster-autoscaler"]
    }
  }
  tags       = local.common_tags
  depends_on = [module.eks.cluster_id]
}

resource "helm_release" "cluster_autoscaler" {
  count            = local.enable_cluster_autoscaler ? 1 : 0
  chart            = "cluster-autoscaler"
  create_namespace = true
  namespace        = local.cluster_autoscaler_namespace
  name             = "cluster-autoscaler"
  version          = var.cluster_autoscaler_chart_version
  repository       = "https://kubernetes.github.io/autoscaler"

  values = [
    data.utils_deep_merge_yaml.values[0].output
  ]

  dynamic "set" {
    for_each = local.cluster_autoscaler_set
    content {
      name  = set.value["name"]
      value = set.value["value"]
    }
  }
}