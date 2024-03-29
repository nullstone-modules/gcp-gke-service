locals {
  cap_startup_probes   = lookup(local.capabilities, "startup_probes", [])
  cap_readiness_probes = lookup(local.capabilities, "readiness_probes", [])
  cap_liveness_probes  = lookup(local.capabilities, "liveness_probes", [])

  startup_probes = [
    for p in local.cap_startup_probes : {
      initial_delay_seconds = lookup(sp.value, "initial_delay")
      period_seconds        = lookup(sp.value, "period")
      timeout_seconds       = lookup(sp.value, "timeout")
      success_threshold     = lookup(sp.value, "success_threshold")
      failure_threshold     = lookup(sp.value, "failure_threshold")

      exec       = compact([lookup(sp.value, "exec", "null")])
      grpc       = compact([lookup(sp.value, "grpc", "null")])
      http_get   = compact([lookup(sp.value, "http_get", "null")])
      tcp_socket = compact([lookup(sp.value, "tcp_socket", "null")])
    }
  ]
  readiness_probes = [
    for p in local.cap_readiness_probes : {
      initial_delay_seconds = lookup(sp.value, "initial_delay")
      period_seconds        = lookup(sp.value, "period")
      timeout_seconds       = lookup(sp.value, "timeout")
      success_threshold     = lookup(sp.value, "success_threshold")
      failure_threshold     = lookup(sp.value, "failure_threshold")

      exec       = compact([lookup(sp.value, "exec", "null")])
      grpc       = compact([lookup(sp.value, "grpc", "null")])
      http_get   = compact([lookup(sp.value, "http_get", "null")])
      tcp_socket = compact([lookup(sp.value, "tcp_socket", "null")])
    }
  ]
  liveness_probes = [
    for p in local.cap_liveness_probes : {
      initial_delay_seconds = lookup(sp.value, "initial_delay")
      period_seconds        = lookup(sp.value, "period")
      timeout_seconds       = lookup(sp.value, "timeout")
      success_threshold     = lookup(sp.value, "success_threshold")
      failure_threshold     = lookup(sp.value, "failure_threshold")

      exec       = compact([lookup(sp.value, "exec", "null")])
      grpc       = compact([lookup(sp.value, "grpc", "null")])
      http_get   = compact([lookup(sp.value, "http_get", "null")])
      tcp_socket = compact([lookup(sp.value, "tcp_socket", "null")])
    }
  ]
}
