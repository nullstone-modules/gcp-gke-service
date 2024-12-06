resource "google_service_account" "image_pusher" {
  account_id   = "pusher-${local.resource_name}"
  display_name = "Image Pusher for ${local.app_name}"
}

resource "google_artifact_registry_repository_iam_member" "member" {
  project    = google_artifact_registry_repository.this.project
  location   = google_artifact_registry_repository.this.location
  repository = google_artifact_registry_repository.this.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.image_pusher.email}"
}

resource "google_service_account_key" "image_pusher" {
  service_account_id = google_service_account.image_pusher.account_id
}
