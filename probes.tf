locals {
  startup_probes = [
    for p in local.capabilities.startup_probes : {
      initial_delay_seconds = lookup(p, "initial_delay_seconds", null)
      period_seconds        = lookup(p, "period_seconds", null)
      timeout_seconds       = lookup(p, "timeout_seconds", null)
      success_threshold     = lookup(p, "success_threshold", null)
      failure_threshold     = lookup(p, "failure_threshold", null)

      exec       = [for x in compact([lookup(p, "exec", null)]) : jsondecode(x)]
      grpc       = [for x in compact([lookup(p, "grpc", null)]) : jsondecode(x)]
      http_get   = [for x in compact([lookup(p, "http_get", null)]) : jsondecode(x)]
      tcp_socket = [for x in compact([lookup(p, "tcp_socket", null)]) : jsondecode(x)]
    }
  ]
  readiness_probes = [
    for p in local.capabilities.readiness_probes : {
      initial_delay_seconds = lookup(p, "initial_delay_seconds", null)
      period_seconds        = lookup(p, "period_seconds", null)
      timeout_seconds       = lookup(p, "timeout_seconds", null)
      success_threshold     = lookup(p, "success_threshold", null)
      failure_threshold     = lookup(p, "failure_threshold", null)

      exec       = [for x in compact([lookup(p, "exec", null)]) : jsondecode(x)]
      grpc       = [for x in compact([lookup(p, "grpc", null)]) : jsondecode(x)]
      http_get   = [for x in compact([lookup(p, "http_get", null)]) : jsondecode(x)]
      tcp_socket = [for x in compact([lookup(p, "tcp_socket", null)]) : jsondecode(x)]
    }
  ]
  liveness_probes = [
    for p in local.capabilities.liveness_probes : {
      initial_delay_seconds = lookup(p, "initial_delay_seconds", null)
      period_seconds        = lookup(p, "period_seconds", null)
      timeout_seconds       = lookup(p, "timeout_seconds", null)
      success_threshold     = lookup(p, "success_threshold", null)
      failure_threshold     = lookup(p, "failure_threshold", null)

      exec       = [for x in compact([lookup(p, "exec", null)]) : jsondecode(x)]
      grpc       = [for x in compact([lookup(p, "grpc", null)]) : jsondecode(x)]
      http_get   = [for x in compact([lookup(p, "http_get", null)]) : jsondecode(x)]
      tcp_socket = [for x in compact([lookup(p, "tcp_socket", null)]) : jsondecode(x)]
    }
  ]
}
