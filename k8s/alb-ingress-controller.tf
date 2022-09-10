locals {
  enable_lb_ingress_controller = false
}

module "load_balancer_controller_irsa_role" {
  source = "./.terraform/modules/aws-eks-iam-role-sa"

  create_role = local.enable_lb_ingress_controller == true ? true : false

  role_name = "load_balancer_controller"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:load-balancer-controller-aws-load-balancer-controller"]
    }
  }
}


resource "helm_release" "aws_loadbalancer_controller" {
  count      = local.enable_lb_ingress_controller == true ? 1 : 0
  depends_on = [module.eks.kubeconfig, module.load_balancer_controller_irsa_role]
  namespace  = "kube-system"
  name       = "load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = var.lb_ingress_chart_version

  dynamic "set" {
    for_each = local.lb_ingress_set
    content {
      name  = set.value["name"]
      value = set.value["value"]
    }
  }
}