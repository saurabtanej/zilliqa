locals {
  priorityClass = [
    {
      name  = "priorityClassName"
      value = "system-cluster-critical"
    }
  ]
}

locals {

  cluster_autoscaler_values = ""
  cluster_autoscaler_set = concat(var.cluster_autoscaler_set, local.priorityClass,
    [
      {
        name  = "resources.limits.memory"
        value = "500Mi"
        type  = "string"
      }
    ]
  )

  external_dns_set = merge(var.external_dns_set,
    {
      "LogLevel"                = "debug",
      "provider"                = "aws",
      "resources.limits.memory" = "500Mi"
    }
  )
  external_dns_values = yamlencode({
    "domainFilters" : data.terraform_remote_state.setup.outputs.private_hosted_zone
    "zoneIdFilters" : var.external_dns_zone_id_filters
  })

  lb_ingress_set = concat(var.lb_ingress_set, local.priorityClass,
    [
      {
        name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
        value = module.load_balancer_controller_irsa_role.iam_role_arn
        type  = "string"
      },
      {
        name  = "clusterName"
        value = local.eks_cluster_name
        type  = "string"
      },
      {
        name  = "region"
        value = data.aws_region.current.name
        type  = "string"
      },
      {
        name  = "resources.limits.cpu"
        value = "500m"
      },
      {
        name  = "resources.limits.memory"
        value = "1Gi"
      },
      {
        name  = "image.repository"
        value = "602401143452.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/amazon/aws-load-balancer-controller"
      }
    ]
  )
}