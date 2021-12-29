locals {
  standard_env_vars = tomap({
    NULLSTONE_ENV = data.ns_workspace.this.env_name
  })
  cap_env_vars = { for item in try(local.capabilities.env, []) : item.name => item.value }
  env_vars     = merge(local.standard_env_vars, var.service_env_vars, local.cap_env_vars)
}
