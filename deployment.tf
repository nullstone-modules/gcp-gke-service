resource "kubernetes_deployment" "deployment" {
  metadata {
    name = local.app_name

    labels = {
      stack = data.ns_workspace.this.stack_name
      env   = data.ns_workspace.this.env_name
      app   = local.app_name
    }
  }

  # Pods specs
  spec {
    replicas = var.service_count

    selector {
      match_labels = {
        app = local.app_name
      }
    }

    template {
      metadata {
        labels = {
          ref   = data.ns_workspace.this.block_ref
          stack = data.ns_workspace.this.stack_name
          env   = data.ns_workspace.this.env_name
          app   = local.app_name
        }
      }

      spec {
        container {
          image = "${local.service_image}:${local.app_version}"
          name  = "main"

          dynamic "env" {
            for_each = local.env_vars

            content {
              name  = env.key
              value = env.value
            }
          }

          resources {
            limits = {
              cpu    = var.service_cpu
              memory = var.service_memory
            }
          }
        }
      }
    }
  }
}
