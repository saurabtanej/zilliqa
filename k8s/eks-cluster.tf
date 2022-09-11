locals {
  eks_managed_default_disk_size = 50
  default_node_group_min        = 2
  default_node_group_desired    = 2
  default_node_group_max        = 5
  additional_policies = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
  eks_cluster_name = "zilliqa-${local.env}"
}

module "eks" {
  source = "./.terraform/modules/aws-eks"

  cluster_name                    = local.eks_cluster_name
  cluster_version                 = 1.23
  cluster_endpoint_private_access = true
  cluster_enabled_log_types       = ["audit", "api", "authenticator"]
  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
    aws-ebs-csi-driver = {
      resolve_conflicts = "OVERWRITE"
    }
  }
  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
    ingress_https = {
      description = "Access from vpc and self"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = [local.vpc_cidr]
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    ingress_cluster_8443 = {
      description                   = "Cluster API to node groups, required by Gatekeeper"
      protocol                      = "tcp"
      from_port                     = 8443
      to_port                       = 8443
      type                          = "ingress"
      source_cluster_security_group = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  manage_aws_auth_configmap = true
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${local.account_id}:user/saurabh"
      username = "user1"
      groups   = ["system:masters"]
    }
  ]

  enable_irsa = true

  vpc_id     = data.terraform_remote_state.setup.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.setup.outputs.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type  = "BOTTLEROCKET_x86_64"
    platform  = "bottlerocket"
    disk_size = local.eks_managed_default_disk_size
    # instance_types               = ["c5.xlarge", "c5d.xlarge", "r5.xlarge", "c5a.xlarge"]
    instance_types               = ["t2.micro"]
    capacity_type                = "SPOT"
    min_size                     = local.default_node_group_min
    max_size                     = local.default_node_group_max
    desired_size                 = local.default_node_group_desired
    iam_role_additional_policies = local.additional_policies
  }

  eks_managed_node_groups = {

    infrastructure = {
      iam_role_name = "infrastructure-node"
      tags          = local.common_tags
      labels = {
        node = "infrastructure"
      }
      # taints = [{
      #   key    = "node"
      #   value  = "infrastructure"
      #   effect = "NO_SCHEDULE"
      # }]
    }

    apps = {
      iam_role_name = "app-node"
      # instance_types = ["m5.xlarge", "m5a.xlarge", "m4.xlarge"]
      instance_types = ["t2.micro"]

      labels = {
        node = "apps"
      }

      # taints = [{
      #   key    = "node"
      #   value  = "apps"
      #   effect = "NO_SCHEDULE"
      # }]
      tags = local.common_tags
    }
  }
}