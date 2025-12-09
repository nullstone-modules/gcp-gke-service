locals {
  max_pusher_name_len = 30 - length("pusher--12345")
  pusher_name         = "pusher-${substr(local.block_ref, 0, local.max_pusher_name_len)}-${random_string.resource_suffix.result}"
}

resource "google_service_account" "image_pusher" {
  account_id   = local.pusher_name
  display_name = "Image Pusher for ${local.app_name}"
}

resource "google_artifact_registry_repository_iam_member" "member" {
  project    = google_artifact_registry_repository.this.project
  location   = google_artifact_registry_repository.this.location
  repository = google_artifact_registry_repository.this.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.image_pusher.email}"
}

// Allow Nullstone Agent to impersonate the pusher account
resource "google_service_account_iam_binding" "image_pusher_nullstone_agent" {
  service_account_id = google_service_account.image_pusher.id
  role               = "roles/iam.serviceAccountTokenCreator"
  members            = ["serviceAccount:${local.ns_agent_service_account_email}"]
}
