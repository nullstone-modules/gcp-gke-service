terraform {
  required_providers {
    ns = {
      source = "nullstone-io/ns"
    }
  }
}

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
  tags          = { for k, v in data.ns_workspace.this.tags : lower(k) => v }
  block_name    = data.ns_workspace.this.block_name
  block_ref     = data.ns_workspace.this.block_ref
  resource_name = "${local.block_ref}-${random_string.resource_suffix.result}"

  match_labels = {
    "nullstone.io/stack"     = data.ns_workspace.this.stack_name
    "nullstone.io/block-ref" = data.ns_workspace.this.block_ref
    "nullstone.io/env"       = data.ns_workspace.this.env_name
  }
  labels = merge({
    // k8s-recommended labels
    "app.kubernetes.io/name"       = local.block_name
    "app.kubernetes.io/version"    = local.app_version
    "app.kubernetes.io/component"  = ""
    "app.kubernetes.io/part-of"    = data.ns_workspace.this.stack_name
    "app.kubernetes.io/managed-by" = "nullstone"
    // nullstone labels
    "nullstone.io/block" = data.ns_workspace.this.block_name
  }, local.match_labels)
  app_labels = merge({
    // k8s-recommended labels
    "app.kubernetes.io/name"       = local.block_name
    "app.kubernetes.io/version"    = local.app_version
    "app.kubernetes.io/component"  = ""
    "app.kubernetes.io/part-of"    = data.ns_workspace.this.stack_name
    "app.kubernetes.io/managed-by" = "nullstone"
    // nullstone labels
    "nullstone.io/app" = data.ns_workspace.this.block_name
  }, local.match_labels)
  repo_labels = {
    "nullstone-stack" = data.ns_workspace.this.stack_name
    "nullstone-block" = data.ns_workspace.this.block_name
    "nullstone-env"   = data.ns_workspace.this.env_name
  }
}
