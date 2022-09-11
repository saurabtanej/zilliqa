resource "aws_secretsmanager_secret" "document_db_credentials" {
  count       = local.ignore_admin_credentials ? 0 : 1
  name        = local.secret_name
  description = "${local.secret_name} document_db credentials"
  tags        = local.common_tags
}

resource "aws_secretsmanager_secret_version" "document_db_credentials" {
  count         = local.ignore_admin_credentials ? 0 : 1
  secret_id     = aws_secretsmanager_secret.document_db_credentials[0].id
  secret_string = jsonencode(local.document_db_credentials)
}

module "documentdb_cluster" {
  source                     = "./.terraform/modules/aws-document-db"
  cluster_size               = local.cluster_size
  master_username            = local.master_username
  instance_class             = local.instance_class
  db_port                    = 27017
  vpc_id                     = data.terraform_remote_state.setup.outputs.vpc_id
  subnet_ids                 = data.terraform_remote_state.setup.outputs.database_subnets
  zone_id                    = data.terraform_remote_state.setup.outputs.private_hosted_zone
  apply_immediately          = true
  auto_minor_version_upgrade = true
  # allowed_security_groups         = data.terraform_remote_state.k8s.outputs.cluster_security_group_id
  allowed_security_groups         = var.allowed_security_groups
  allowed_cidr_blocks             = [local.vpc_cidr]
  snapshot_identifier             = var.snapshot_identifier
  retention_period                = local.retention_period
  preferred_backup_window         = local.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  cluster_parameters              = var.cluster_parameters
  cluster_family                  = local.cluster_family
  engine                          = local.engine
  engine_version                  = local.engine_version
  storage_encrypted               = var.storage_encrypted
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  cluster_dns_name                = local.cluster_dns_name
  reader_dns_name                 = local.reader_dns_name
  context                         = module.this.context
}