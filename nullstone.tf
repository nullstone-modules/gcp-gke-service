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