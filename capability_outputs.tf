locals {
  // This indicates which outputs are supported by this app module
  // When adding support for a new output, add it to this list; the output will be available at "local.capabilities.<output_name>"
  capability_output_names = [
    "env",
    "secrets",
    "private_urls",
    "public_urls",
    "metrics",
    "volumes",
    "volume_mounts",
    "startup_probes",
    "readiness_probes",
    "liveness_probes",
  ]
}
