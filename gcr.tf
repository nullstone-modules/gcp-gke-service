resource "google_container_registry" "registry" {}

data "google_container_registry_image" "image" {
  name = data.ns_workspace.this.block_name
}
