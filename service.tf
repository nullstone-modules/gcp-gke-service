resource "kubernetes_service" "service" {
  metadata {
    name = data.ns_workspace.this.block_ref
    labels = {
      app = local.service_name
    }
  }
  spec {
    selector = {
      app = local.service_name
    }
    session_affinity = "ClientIP"
    port {
      port        = var.lb_port
      target_port = var.container_port
    }

    type = "LoadBalancer"
  }

  count = var.enable_lb ? 1 : 0
}
