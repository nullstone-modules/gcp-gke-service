output "service_image" {
  value       = "${local.service_image}:${local.app_version}"
  description = "string ||| Service container image url."
}

output "lb_ip" {
  value       = try(kubernetes_service.service[0].status[0].load_balancer[0].ingress[0].ip, "")
  description = "string ||| IP address of load balancer."
}