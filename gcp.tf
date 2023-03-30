data "google_client_config" "this" {}

locals {
  region     = data.google_client_config.this.region
  zone       = data.google_client_config.this.zone
  project_id = data.google_client_config.this.project
}
