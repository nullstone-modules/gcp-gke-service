resource "random_string" "resource_suffix" {
  length  = 5
  lower   = true
  upper   = false
  number  = false
  special = false
}

locals {
  service_name  = var.service_name != "" ? var.service_name : "${data.ns_workspace.this.block_ref}"
  service_image = var.service_image != "" ? var.service_image : "${data.google_container_registry_image.image.image_url}"
}

