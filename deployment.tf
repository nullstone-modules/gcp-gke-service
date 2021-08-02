resource "kubernetes_deployment" "deployment" {
  metadata {
    name = data.ns_workspace.this.block_ref
    labels = {
      app = data.ns_workspace.this.block_name
    }
  }

  # Pods specs
  spec {
    replicas = var.service_count

    selector {
      match_labels = {
        app = data.ns_workspace.this.block_name
      }
    }

    template {
      metadata {
        labels = {
          app = data.ns_workspace.this.block_name
        }
      }

      spec {
        container {
          image = "${local.service_image}:${local.app_version}"
          name  = data.ns_workspace.this.block_name

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