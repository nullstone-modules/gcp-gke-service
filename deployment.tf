locals {
  main_container_name = "main"
}

resource "kubernetes_deployment" "this" {
  wait_for_rollout = false

  metadata {
    name      = local.app_name
    namespace = local.app_namespace
    labels    = local.app_labels
  }

  # Pods specs
  spec {
    replicas = var.replicas

    selector {
      match_labels = local.app_labels
    }

    template {
      metadata {
        labels = local.app_labels
      }

      spec {
        restart_policy       = "Always"
        service_account_name = kubernetes_service_account.app.metadata[0].name

        container {
          name  = local.main_container_name
          image = "${local.service_image}:${local.app_version}"

          resources {
            limits = {
              cpu    = var.cpu
              memory = var.memory
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
