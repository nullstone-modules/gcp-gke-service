data "google_client_config" "this" {}
data "google_project" "this" {}

locals {
  region         = data.google_client_config.this.region
  zone           = data.google_client_config.this.zone
  project_id     = data.google_client_config.this.project
  project_number = data.google_project.this.number
}
