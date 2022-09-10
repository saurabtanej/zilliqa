locals {
  ignore_admin_credentials = var.snapshot_identifier != null || var.ignore_admin_credentials
  document_db_credentials = {
    db_endpoint = module.documentdb_cluster.endpoint
    admin_user  = "admin"
  }
  secret_name             = "zilliqa-document-db"
  cluster_size            = 3
  master_username         = "admin"
  instance_class          = "db.r6g.large"
  retention_period        = 35
  preferred_backup_window = "07:00-09:00"
  cluster_family          = "docdb4.0.0"
  engine                  = "docdb"
  engine_version          = "4.0.0"
  cluster_dns_name        = "document-db.private.zilliqa.co"
  reader_dns_name         = "document-db-reader.private.zilliqa.co"
}
