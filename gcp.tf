data "google_compute_zones" "available" {}

locals {
  project_id = data.google_compute_zones.available.project
}