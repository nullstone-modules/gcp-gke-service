data "ns_app_env" "this" {
  stack_id = data.ns_workspace.this.stack_id
  app_id   = data.ns_workspace.this.block_id
  env_id   = data.ns_workspace.this.env_id
}

locals {
  app_namespace = local.kubernetes_namespace
  app_name      = data.ns_workspace.this.block_name
  app_version   = coalesce(data.ns_app_env.this.version, "latest")
}

locals {
  app_metadata = tomap({
    // Inject app metadata into capabilities here (e.g. service_account_id)
    service_account_id    = google_service_account.app.id
    service_account_email = google_service_account.app.email
    service_name          = kubernetes_service_v1.this.metadata[0].name
    service_port          = local.service_port
  })
}
