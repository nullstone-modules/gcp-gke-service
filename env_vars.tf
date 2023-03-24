variable "env_vars" {
  type        = map(string)
  default     = {}
  description = <<EOF
The environment variables to inject into the service.
These are typically used to configure a service per environment.
It is dangerous to put sensitive information in this variable because they are not protected and could be unintentionally exposed.
EOF
}

variable "secrets" {
  type        = map(string)
  default     = {}
  sensitive   = true
  description = <<EOF
The sensitive environment variables to inject into the service.
These are typically used to configure a service per environment.
EOF
}

locals {
  standard_env_vars = tomap({
    NULLSTONE_STACK         = data.ns_workspace.this.stack_name
    NULLSTONE_APP           = data.ns_workspace.this.block_name
    NULLSTONE_ENV           = data.ns_workspace.this.env_name
    NULLSTONE_VERSION       = data.ns_app_env.this.version
    NULLSTONE_COMMIT_SHA    = data.ns_app_env.this.commit_sha
    NULLSTONE_PUBLIC_HOSTS  = join(",", local.public_hosts)
    NULLSTONE_PRIVATE_HOSTS = join(",", local.private_hosts)
  })

  input_env_vars = merge(local.standard_env_vars, local.cap_env_vars, var.env_vars)
  input_secrets  = merge(local.cap_secrets, var.secrets)
}

data "ns_env_variables" "this" {
  input_env_variables = local.input_env_vars
  input_secrets       = local.input_secrets
}

data "ns_secret_keys" "this" {
  input_env_variables = var.env_vars
  input_secret_keys   = nonsensitive(keys(local.input_secrets))
}

locals {
  secret_keys  = data.ns_secret_keys.this.secret_keys
  all_secrets  = data.ns_env_variables.this.secrets
  all_env_vars = data.ns_env_variables.this.env_variables
}
