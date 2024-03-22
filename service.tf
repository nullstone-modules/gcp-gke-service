locals {
  has_service  = var.port == 0 ? false : true
  service_name = var.port == 0 ? "" : local.app_name
}

resource "kubernetes_service_v1" "this" {
  count = local.has_service ? 1 : 0

  metadata {
    name      = local.service_name
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
      port        = local.service_port
      target_port = var.port
    }
  }
}
