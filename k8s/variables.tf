variable "cluster_autoscaler_chart_version" {
  description = "Helm Chart version of Cluster Autoscaler"
  default     = "9.18.0"
  type        = string
}

variable "cluster_autoscaler_set" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "Additional settings which will be passed to the Helm chart values, see https://hub.helm.sh/charts/stable/cluster-autoscaler"
}

variable "external_dns_helm_chart_version" {
  description = "Helm Chart version of External DNS"
  default     = "6.2.5"
  type        = string
}

variable "policy_allowed_zone_ids" {
  type        = list(string)
  default     = ["*"]
  description = "List of the Route53 zone ids for service account IAM role access"
}

variable "external_dns_zone_id_filters" {
  description = "Limit possible target zones by domain suffixes"
  type        = list(any)
  default     = []
}

variable "external_dns_set" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://hub.helm.sh/charts/stable/cluster-autoscaler"
}

variable "lb_ingress_chart_version" {
  description = "Helm Chart version of Load Balancer Controller"
  default     = "1.4.1"
  type        = string
}

variable "lb_ingress_set" {
  description = "Value block with custom values to be merged with the values yaml"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
