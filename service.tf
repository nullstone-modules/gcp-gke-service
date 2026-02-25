locals {
  has_service  = var.service_port == 0 || var.container_port == 0 ? false : true
  service_name = !local.has_service ? "" : local.app_name

  base_service_annotations = tomap({
    "cloud.google.com/neg" = jsonencode({ ingress : true })
  })
  cap_service_annotations = tomap({ for ann in local.capabilities.service_annotations : ann.name => ann.value })
  service_annotations     = merge(local.base_service_annotations, local.cap_service_annotations)
}

resource "kubernetes_service_v1" "this" {
  count = local.has_service ? 1 : 0

  lifecycle {
    ignore_changes = [
      metadata[0].annotations["cloud.google.com/neg"],
      metadata[0].annotations["cloud.google.com/neg-status"],
    ]
  }

  metadata {
    name        = local.service_name
    namespace   = local.app_namespace
    labels      = local.app_labels
    annotations = local.service_annotations
  }

  spec {
    type = "ClusterIP"

    selector = local.match_labels

    port {
      port        = var.service_port
      target_port = var.container_port
    }
  }
}
