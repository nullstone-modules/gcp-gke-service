resource "kubernetes_service" "service" {
  metadata {
    name = data.ns_workspace.this.block_ref
    labels = {
      app = data.ns_workspace.this.block_name
    }
  }
  spec {
    selector = {
      app = data.ns_workspace.this.block_name
    }
    session_affinity = "ClientIP"
    port {
      port        = var.lb_port
      target_port = var.service_port
    }

    type = "LoadBalancer"
  }

  count = var.enable_lb ? 1 : 0
}
