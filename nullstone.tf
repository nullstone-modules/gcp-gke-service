terraform {
  required_providers {
    ns = {
      source = "nullstone-io/ns"
    }
  }
}

data "ns_workspace" "this" {}

data "ns_connection" "cluster" {
  name = "cluster"
  type = "cluster/gcp-gke"
}

resource "random_string" "resource_suffix" {
  length  = 5
  lower   = true
  upper   = false
  number  = false
  special = false
}

locals {
  resource_name          = "${data.ns_workspace.this.block_ref}-${random_string.resource_suffix.result}"
  service_image          = var.service_image != "" ? var.service_image : data.google_container_registry_image.this.image_url
  cluster_endpoint       = data.ns_connection.cluster.outputs.cluster_endpoint
  cluster_ca_certificate = data.ns_connection.cluster.outputs.cluster_ca_certificate
}
