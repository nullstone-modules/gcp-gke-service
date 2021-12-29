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
