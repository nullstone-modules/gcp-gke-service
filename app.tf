data "ns_app_env" "this" {
  stack_id = data.ns_workspace.this.stack_id
  app_id   = data.ns_workspace.this.block_id
  env_id   = data.ns_workspace.this.env_id
}

locals {
  app_namespace = "default"
  app_name      = data.ns_workspace.this.block_name
  app_version   = data.ns_app_env.this.version
}
