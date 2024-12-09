resource "google_service_account" "app" {
  account_id   = local.resource_name
  display_name = "Service Account for Nullstone App ${local.app_name}"
}

resource "kubernetes_service_account_v1" "app" {
  metadata {
    namespace = local.app_namespace
    name      = local.app_name
    labels    = local.app_labels

    annotations = {
      // This indicates which GCP service account this kubernetes service account can impersonate
      "iam.gke.io/gcp-service-account" = google_service_account.app.email
    }
  }

  automount_service_account_token = true
}

// This allows the kubernetes service account <app-namespace>/<app-name> to impersonate a workload identity
resource "google_service_account_iam_member" "app_workload_identity" {
  service_account_id = google_service_account.app.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${local.project_id}.svc.id.goog[${local.app_namespace}/${local.app_name}]"
}

resource "google_service_account_iam_member" "app_generate_token" {
  service_account_id = google_service_account.app.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${local.project_id}.svc.id.goog[${local.app_namespace}/${local.app_name}]"
}

// See https://cloud.google.com/kubernetes-engine/docs/tutorials/workload-identity-secrets
resource "google_secret_manager_secret_iam_member" "k8s_access" {
  for_each = local.secret_keys

  secret_id = google_secret_manager_secret.app_secret[each.key].secret_id
  project   = local.project_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.app.email}"
}
