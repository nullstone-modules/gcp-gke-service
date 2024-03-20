locals {
  main_container_name = "main"
  command             = length(var.command) > 0 ? var.command : null
}

resource "kubernetes_deployment_v1" "this" {
  #bridgecrew:skip=CKV_K8S_35: "Prefer using secrets as files over secrets as environment variables". Secrets are provided as env vars for easier integration.
  #bridgecrew:skip=CKV_K8S_43: "Image should use digest". Image digest is not available yet.
  wait_for_rollout = false

  depends_on = [kubernetes_manifest.secrets_from_gsm]

  metadata {
    name      = local.app_name
    namespace = local.app_namespace
    labels    = local.app_labels
  }

  # Pods specs
  spec {
    replicas = var.replicas

    selector {
      match_labels = local.match_labels
    }

    template {
      metadata {
        labels = local.app_labels
      }

      spec {
        restart_policy       = "Always"
        service_account_name = kubernetes_service_account_v1.app.metadata[0].name

        container {
          name  = local.main_container_name
          image = "${local.service_image}:${local.app_version}"
          args  = local.command

          security_context {
            capabilities {
              drop = ["ALL"]
            }
          }

          resources {
            requests = {
              cpu    = var.cpu
              memory = var.memory
            }

            limits = {
              cpu    = var.cpu
              memory = var.memory
            }
          }

          liveness_probe {
            failure_threshold     = 3
            success_threshold     = 1
            initial_delay_seconds = var.readiness_delay
            period_seconds        = 10
            timeout_seconds       = 1


            tcp_socket {
              port = var.port
            }
          }

          readiness_probe {
            failure_threshold     = 3
            success_threshold     = 1
            initial_delay_seconds = var.readiness_delay
            period_seconds        = 10
            timeout_seconds       = 1

            tcp_socket {
              port = var.port
            }
          }

          dynamic "port" {
            for_each = var.port > 0 ? [var.port] : []

            content {
              container_port = port.value
            }
          }

          dynamic "env" {
            for_each = local.all_env_vars

            content {
              name  = env.key
              value = env.value
            }
          }

          dynamic "env" {
            for_each = local.secret_keys

            content {
              name = env.value

              value_from {
                secret_key_ref {
                  name = "${local.resource_name}-gsm-secrets"
                  key  = env.value
                }
              }
            }
          }
        }
      }
    }
  }
}
