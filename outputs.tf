output "image_repo_url" {
  value       = data.google_container_registry_image.this.image_url
  description = "string ||| Service container image url."
}

output "log_provider" {
  value       = "gcp"
  description = "string ||| The log provider used for this service."
}

output "service_image" {
  value       = "${local.service_image}:${local.app_version}"
  description = "string ||| "
}

output "service_name" {
  value       = kubernetes_deployment.deployment.metadata.name
  description = "string ||| "
}

output "image_pusher" {
  value = {
    email       = try(google_service_account.image_pusher[0].email, "")
    private_key = try(google_service_account_key.image_pusher[0].private_key, "")
  }

  description = "object({ email: string, private_key: string }) ||| A GCP service account containing a base64-encoded JSON private key file."

  sensitive = true
}
