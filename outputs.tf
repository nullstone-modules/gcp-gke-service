output "image_repo_url" {
  value       = local.repository_url
  description = "string ||| Service container image url."
}

output "log_provider" {
  value       = "gcp"
  description = "string ||| The log provider used for this service."
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
    email       = try(google_service_account.image_pusher.email, "")
    private_key = try(google_service_account_key.image_pusher.private_key, "")
  }

  description = "object({ email: string, private_key: string }) ||| A GCP service account that is allowed to push images."

  sensitive = true
}

output "deployer" {
  value = {
    email       = try(google_service_account.deployer.email, "")
    private_key = try(google_service_account_key.deployer.private_key, "")
  }

  description = "object({ email: string, private_key: string }) ||| A GCP service account with explicit privilege to deploy this GKE service to its cluster."
  sensitive   = true
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
