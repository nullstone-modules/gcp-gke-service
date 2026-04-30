data "ns_app_env" "this" {
  stack_id = data.ns_workspace.this.stack_id
  app_id   = data.ns_workspace.this.block_id
  env_id   = data.ns_workspace.this.env_id
}

locals {
  app_namespace  = local.kubernetes_namespace
  app_name       = data.ns_workspace.this.block_name
  app_version    = coalesce(data.ns_app_env.this.version, "latest")
  app_commit_sha = data.ns_app_env.this.commit_sha
}

locals {
  app_metadata = tomap({
    // Inject app metadata into capabilities here (e.g. service_account_id)
    service_account_id    = module.scaffold.app_service_account.id
    service_account_email = module.scaffold.app_service_account.email
    service_name          = local.service_name
    container_port        = var.container_port
    service_port          = var.service_port
    internal_subdomain    = var.service_port == 0 ? "" : "${local.block_name}.${local.kubernetes_namespace}.svc.cluster.local"
    // Shared external-secrets SecretStore in the app's namespace. Capabilities can
    // reference this to create ExternalSecrets without standing up their own store.
    // Reading the name through the resource attribute (instead of local.app_secret_store_name)
    // makes capabilities wait on the SecretStore being applied before their ExternalSecrets run.
    secret_store_name = kubernetes_manifest.gsm_secret_store.manifest.metadata.name
  })
}
