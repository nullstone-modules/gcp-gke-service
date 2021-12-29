output "image_repo_url" {
  value       = data.google_container_registry_image.this.image_url
  description = "string ||| Service container image url."
}

output "log_provider" {
  value       = "gcp"
  description = "string ||| The log provider used for this service."
}

output "service_name" {
  value       = local.app_name
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

output "main_container_name" {
  value       = local.main_container_name
  description = "string ||| The name of the container definition for the main service container"
}

locals {
  additional_private_urls = []
  additional_public_urls  = []
}

output "private_urls" {
  value = concat([for url in try(local.capabilities.private_urls, []) : url["url"]], local.additional_private_urls)
}

output "public_urls" {
  value = concat([for url in try(local.capabilities.public_urls, []) : url["url"]], local.additional_public_urls)
}
