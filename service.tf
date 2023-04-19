resource "kubernetes_service" "this" {
  metadata {
    name      = local.app_name
    namespace = local.app_namespace
    labels    = local.app_labels

    annotations = {
      "cloud.google.com/neg" = jsonencode({ ingress : true })
    }
  }

  spec {
    type = "ClusterIP"

    selector = local.match_labels

    port {
      port        = var.port
      target_port = var.port
    }
  }
}
