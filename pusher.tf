resource "google_service_account" "image_pusher" {
  account_id   = "pusher-${local.resource_name}"
  display_name = "Image Pusher for ${local.app_name}"
}

resource "google_storage_bucket_iam_member" "service_push_image" {
  bucket = google_container_registry.registry.id
  role   = "roles/storage.legacyBucketWriter"
  member = "serviceAccount:${google_service_account.image_pusher.email}"
}

resource "google_service_account_key" "image_pusher" {
  service_account_id = google_service_account.image_pusher.account_id
}
