resource "google_service_account" "app" {
  account_id   = local.resource_name
  display_name = "Service Account for Nullstone App ${local.app_name}"
}

resource "kubernetes_service_account" "app" {
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
resource "google_project_iam_member" "app_workload_identity" {
  role    = "roles/iam.workloadIdentityUser"
  member  = "serviceAccount:${local.project_id}.svc.id.goog[${local.app_namespace}/${local.app_name}]"
  project = local.project_id
}
