resource "kubernetes_deployment" "deployment" {
  metadata {
    name = data.ns_workspace.this.block_ref
    labels = {
      app = local.service_name
    }
  }

  # Pods specs
  spec {
    replicas = var.pods_replica_count

    selector {
      match_labels = {
        app = local.service_name
      }
    }

    template {
      metadata {
        labels = {
          app = local.service_name
        }
      }

      spec {
        container {
          image = "${local.service_image}:${local.app_version}"
          name  = local.service_name

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