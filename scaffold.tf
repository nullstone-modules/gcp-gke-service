module "scaffold" {
  source = "registry.terraform.io/nullstone-modules/gke-appscaffold/google"

  project_id                      = local.project_id
  region                          = local.region
  app_name                        = local.app_name
  block_ref                       = local.block_ref
  resource_suffix                 = random_string.resource_suffix.result
  repo_labels                     = local.repo_labels
  op_impersonater_emails          = [local.ns_agent_service_account_email]
  image_url                       = var.image_url
  kubernetes_namespace            = local.kubernetes_namespace
  kubernetes_service_account_name = local.app_name
}

locals {
  repository_url = module.scaffold.repository_url
}

// State migration for resources extracted into the gke-appscaffold module.
// These can be removed once every environment has been successfully applied
// against the new module layout.

moved {
  from = google_artifact_registry_repository.this[0]
  to   = module.scaffold.google_artifact_registry_repository.this[0]
}

moved {
  from = google_service_account.app
  to   = module.scaffold.google_service_account.app
}

moved {
  from = google_service_account_iam_member.app_workload_identity
  to   = module.scaffold.google_service_account_iam_member.app_workload_identity
}

moved {
  from = google_service_account_iam_member.app_generate_token
  to   = module.scaffold.google_service_account_iam_member.app_generate_token_k8s
}

moved {
  from = google_service_account_iam_member.app_generate_token_self
  to   = module.scaffold.google_service_account_iam_member.app_generate_token_self
}

moved {
  from = google_service_account.image_pusher
  to   = module.scaffold.google_service_account.image_pusher
}

moved {
  from = google_artifact_registry_repository_iam_member.member[0]
  to   = module.scaffold.google_artifact_registry_repository_iam_member.image_pusher_writer[0]
}

moved {
  from = google_service_account_iam_binding.image_pusher_nullstone_agent
  to   = module.scaffold.google_service_account_iam_binding.image_pusher_impersonators
}

moved {
  from = google_service_account.deployer
  to   = module.scaffold.google_service_account.deployer
}

moved {
  from = google_project_iam_member.deployer_developer_access
  to   = module.scaffold.google_project_iam_member.deployer_developer_access
}

moved {
  from = google_service_account_iam_binding.deployer_nullstone_agent
  to   = module.scaffold.google_service_account_iam_binding.deployer_impersonators
}

moved {
  from = google_project_iam_member.deployer_metrics_viewer
  to   = module.scaffold.google_project_iam_member.deployer_metrics_viewer
}
