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

      exec       = compact([lookup(p, "exec", null)])
      grpc       = compact([lookup(p, "grpc", null)])
      http_get   = compact([lookup(p, "http_get", null)])
      tcp_socket = compact([lookup(p, "tcp_socket", null)])
    }
  ]
  readiness_probes = [
    for p in local.cap_readiness_probes : {
      initial_delay_seconds = lookup(p, "initial_delay_seconds")
      period_seconds        = lookup(p, "period_seconds")
      timeout_seconds       = lookup(p, "timeout_seconds")
      success_threshold     = lookup(p, "success_threshold")
      failure_threshold     = lookup(p, "failure_threshold")

      exec       = compact([lookup(p, "exec", null)])
      grpc       = compact([lookup(p, "grpc", null)])
      http_get   = compact([lookup(p, "http_get", null)])
      tcp_socket = compact([lookup(p, "tcp_socket", null)])
    }
  ]
  liveness_probes = [
    for p in local.cap_liveness_probes : {
      initial_delay_seconds = lookup(p, "initial_delay_seconds")
      period_seconds        = lookup(p, "period_seconds")
      timeout_seconds       = lookup(p, "timeout_seconds")
      success_threshold     = lookup(p, "success_threshold")
      failure_threshold     = lookup(p, "failure_threshold")

      exec       = compact([lookup(p, "exec", null)])
      grpc       = compact([lookup(p, "grpc", null)])
      http_get   = compact([lookup(p, "http_get", null)])
      tcp_socket = compact([lookup(p, "tcp_socket", null)])
    }
  ]
}
