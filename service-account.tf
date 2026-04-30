resource "kubernetes_service_account_v1" "app" {
  metadata {
    namespace = local.app_namespace
    name      = local.app_name
    labels    = local.k8s_component_labels

    annotations = {
      // This indicates which GCP service account this kubernetes service account can impersonate
      "iam.gke.io/gcp-service-account" = module.scaffold.app_service_account.email
    }
  }

  automount_service_account_token = true
}

// See https://cloud.google.com/kubernetes-engine/docs/tutorials/workload-identity-secrets
resource "google_secret_manager_secret_iam_member" "k8s_access" {
  for_each = local.all_secret_keys

  secret_id = local.all_secrets[each.value]
  project   = local.project_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${module.scaffold.app_service_account.email}"
}
