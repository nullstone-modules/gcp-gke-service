data "ns_app_env" "this" {
  stack_id = data.ns_workspace.this.stack_id
  app_id   = data.ns_workspace.this.block_id
  env_id   = data.ns_workspace.this.env_id
}

locals {
  app_namespace = "default"
  app_name      = data.ns_workspace.this.block_name
  app_version   = coalesce(data.ns_app_env.this.version, "latest")
}

locals {
  app_metadata = tomap({
    // Inject app metadata into capabilities here (e.g. security_group_name, role_name)
  })
}
