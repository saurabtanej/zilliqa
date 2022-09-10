locals {
  enable_external_dns = false
}

module "eks-external-dns" {
  source = "./.terraform/modules/k8s-external-dns"

  enabled = local.enable_external_dns == true ? true : false

  cluster_identity_oidc_issuer     = module.eks.oidc_provider
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  helm_chart_version               = var.external_dns_helm_chart_version
  policy_allowed_zone_ids          = var.policy_allowed_zone_ids
  values                           = local.external_dns_values
  settings                         = local.external_dns_set
}