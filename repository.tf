resource "google_artifact_registry_repository" "this" {
  count = var.image_url == "" ? 1 : 0

  location      = local.region
  repository_id = local.resource_name
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }

  labels = local.repo_labels
}

locals {
  repository_url = var.image_url == "" ? "${google_artifact_registry_repository.this[0].location}-docker.pkg.dev/${google_artifact_registry_repository.this[0].project}/${google_artifact_registry_repository.this[0].name}/${local.app_name}" : var.image_url
}
