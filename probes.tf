locals {
  cap_startup_probes   = lookup(local.capabilities, "startup_probes", [])
  cap_readiness_probes = lookup(local.capabilities, "readiness_probes", [])
  cap_liveness_probes  = lookup(local.capabilities, "liveness_probes", [])

  startup_probes = [
    for p in local.cap_startup_probes : {
      initial_delay_seconds = lookup(p, "initial_delay_seconds")
      period_seconds        = lookup(p, "period_seconds")
      timeout_seconds       = lookup(p, "timeout_seconds")
      success_threshold     = lookup(p, "success_threshold")
      failure_threshold     = lookup(p, "failure_threshold")

      exec       = [for x in compact([lookup(p, "exec", null)]) : jsondecode(x)]
      grpc       = [for x in compact([lookup(p, "grpc", null)]) : jsondecode(x)]
      http_get   = [for x in compact([lookup(p, "http_get", null)]) : jsondecode(x)]
      tcp_socket = [for x in compact([lookup(p, "tcp_socket", null)]) : jsondecode(x)]
    }
  ]
  readiness_probes = [
    for p in local.cap_readiness_probes : {
      initial_delay_seconds = lookup(p, "initial_delay_seconds")
      period_seconds        = lookup(p, "period_seconds")
      timeout_seconds       = lookup(p, "timeout_seconds")
      success_threshold     = lookup(p, "success_threshold")
      failure_threshold     = lookup(p, "failure_threshold")

      exec       = [for x in compact([lookup(p, "exec", null)]) : jsondecode(x)]
      grpc       = [for x in compact([lookup(p, "grpc", null)]) : jsondecode(x)]
      http_get   = [for x in compact([lookup(p, "http_get", null)]) : jsondecode(x)]
      tcp_socket = [for x in compact([lookup(p, "tcp_socket", null)]) : jsondecode(x)]
    }
  ]
  liveness_probes = [
    for p in local.cap_liveness_probes : {
      initial_delay_seconds = lookup(p, "initial_delay_seconds")
      period_seconds        = lookup(p, "period_seconds")
      timeout_seconds       = lookup(p, "timeout_seconds")
      success_threshold     = lookup(p, "success_threshold")
      failure_threshold     = lookup(p, "failure_threshold")

      exec       = [for x in compact([lookup(p, "exec", null)]) : jsondecode(x)]
      grpc       = [for x in compact([lookup(p, "grpc", null)]) : jsondecode(x)]
      http_get   = [for x in compact([lookup(p, "http_get", null)]) : jsondecode(x)]
      tcp_socket = [for x in compact([lookup(p, "tcp_socket", null)]) : jsondecode(x)]
    }
  ]
}
