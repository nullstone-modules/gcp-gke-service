data "ns_connection" "cluster" {
  name     = "cluster"
  contract = "cluster/gcp/k8s:gke"
}

locals {
  service_image          = data.google_container_registry_image.this.image_url
  cluster_endpoint       = data.ns_connection.cluster.outputs.cluster_endpoint
  cluster_ca_certificate = data.ns_connection.cluster.outputs.cluster_ca_certificate
}
