provider "google" {}

data "google_client_config" "provider" {}

provider "kubernetes" {
  host  = data.ns_connection.cluster.outputs.cluster_endpoint
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.ns_connection.cluster.outputs.cluster_ca_certificate
  )
}