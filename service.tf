resource "kubernetes_service_v1" "this" {
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
      port        = 80
      target_port = var.port
    }
  }
}
