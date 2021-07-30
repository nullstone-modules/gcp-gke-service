resource "google_container_registry" "registry" {}

data "google_container_registry_image" "image" {
  name = local.service_name
}
