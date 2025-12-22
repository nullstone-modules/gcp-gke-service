output "project_id" {
  value       = local.project_id
  description = "string ||| The GCP Project ID where this application is hosted."
}

output "image_repo_url" {
  value       = local.repository_url
  description = "string ||| Service container image url."
}

output "log_provider" {
  value       = "gke"
  description = "string ||| The log provider used for this service."
}

output "metrics_provider" {
  value       = "cloudmonitoring"
  description = "string ||| "
}

output "metrics_reader" {
  value = {
    project_id  = local.project_id
    email       = try(google_service_account.deployer.email, "")
    impersonate = true
  }

  description = "object({ email: string, impersonate: bool }) ||| A GCP service account with explicit privilege to view metrics for this application."
}

output "metrics_mappings" {
  value       = local.metrics_mappings
  description = "string ||| A mapping of metric definitions used to render app metrics in the Nullstone UI."
}

output "service_name" {
  value       = local.app_name
  description = "string ||| The name of the kubernetes deployment for the app."
}

output "service_namespace" {
  value       = local.app_namespace
  description = "string ||| The kubernetes namespace where the app resides."
}

output "image_pusher" {
  value = {
    project_id  = local.project_id
    email       = try(google_service_account.image_pusher.email, "")
    impersonate = true
  }

  description = "object({ email: string, impersonate: bool }) ||| A GCP service account that is allowed to push images."
}

output "deployer" {
  value = {
    project_id  = local.project_id
    email       = try(google_service_account.deployer.email, "")
    impersonate = true
  }

  description = "object({ email: string, impersonate: bool }) ||| A GCP service account with explicit privilege to deploy this GKE service to its cluster."
}

output "main_container_name" {
  value       = local.main_container_name
  description = "string ||| The name of the container definition for the main service container"
}

output "private_urls" {
  value       = local.private_urls
  description = "list(string) ||| A list of URLs only accessible inside the network"
}

output "public_urls" {
  value       = local.public_urls
  description = "list(string) ||| A list of URLs accessible to the public"
}
