resource "google_container_registry" "registry" {}

data "google_container_registry_image" "this" {
  name = local.app_name
}
