resource "random_string" "resource_suffix" {
  length  = 5
  lower   = true
  upper   = false
  number  = false
  special = false
}

locals {
  service_image = var.service_image != "" ? var.service_image : "${data.google_container_registry_image.this.image_url}"
}

