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

locals {
  cluster_endpoint       = data.ns_connection.cluster.outputs.cluster_endpoint
  cluster_ca_certificate = data.ns_connection.cluster.outputs.cluster_ca_certificate
}
