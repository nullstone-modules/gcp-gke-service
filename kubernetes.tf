data "google_client_config" "provider" {}

provider "kubernetes" {
  host                   = local.cluster_endpoint
  token                  = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
}
