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
    labels      = local.k8s_component_labels
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

resource "kubernetes_manifest" "backend_policy" {
  count = local.has_service ? 1 : 0

  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "GCPBackendPolicy"

    metadata = {
      name      = local.service_name
      namespace = local.app_namespace
      labels    = local.k8s_component_labels
    }

    spec = {
      targetRef = {
        group = ""
        kind  = "Service"
        name  = local.service_name
      }

      default = merge(
        {
          timeoutSec = var.backend_policy.timeout_sec
          logging = {
            enabled    = var.backend_policy.logging.enabled
            sampleRate = var.backend_policy.logging.sample_rate
          }
        },
        var.backend_policy.connection_draining != null ? {
          connectionDraining = {
            drainingTimeoutSec = var.backend_policy.connection_draining.timeout_sec
          }
        } : {},
        var.backend_policy.session_affinity != null ? {
          sessionAffinity = {
            type         = var.backend_policy.session_affinity.type
            cookieTtlSec = var.backend_policy.session_affinity.cookie_ttl_sec
          }
        } : {},
      )
    }
  }
}
