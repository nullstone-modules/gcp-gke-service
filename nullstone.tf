data "ns_workspace" "this" {}

data "ns_agent" "this" {}

locals {
  ns_agent_service_account_email = data.ns_agent.this.gcp_service_account_email
}

// Generate a random suffix to ensure uniqueness of resources
resource "random_string" "resource_suffix" {
  length  = 5
  lower   = true
  upper   = false
  numeric = false
  special = false
}

locals {
  tags          = data.ns_workspace.this.gcp_labels
  stack_name    = data.ns_workspace.this.stack_name
  env_name      = data.ns_workspace.this.env_name
  block_name    = data.ns_workspace.this.block_name
  block_ref     = data.ns_workspace.this.block_ref
  resource_name = "${local.block_ref}-${random_string.resource_suffix.result}"

  match_labels = {
    "nullstone.io/stack"     = data.ns_workspace.this.stack_name
    "nullstone.io/block-ref" = data.ns_workspace.this.block_ref
    "nullstone.io/env"       = data.ns_workspace.this.env_name
  }

  // Component-level labels: the workspace's default Kubernetes labels plus the app key.
  k8s_component_labels = merge(data.ns_workspace.this.k8s_labels, {
    "nullstone.io/app" = local.block_name
  })

  // App/pod labels: the workspace's default Kubernetes labels plus the running version and app key.
  app_labels = merge(data.ns_workspace.this.k8s_labels, {
    "app.kubernetes.io/version" = local.app_version
    "nullstone.io/app"          = local.block_name
  })

  repo_labels = {
    "nullstone-stack" = data.ns_workspace.this.stack_name
    "nullstone-block" = data.ns_workspace.this.block_name
    "nullstone-env"   = data.ns_workspace.this.env_name
  }
}
