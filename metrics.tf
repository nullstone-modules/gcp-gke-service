locals {
  metrics_mappings = concat(local.base_metrics, local.cap_metrics)

  cap_metrics = []

  // Resources
  // - https://cloud.google.com/stackdriver/docs/managed-prometheus/promql
  pod_name_regex = "^${local.app_name}-[0-9a-f]{10}-.*$"
  query_filter   = "monitored_resource=\"k8s_container\",cluster_name=\"${local.cluster_name}\",namespace_name=\"${local.app_namespace}\",pod_name=~\"${local.pod_name_regex}\""

  base_metrics = [
    {
      name = "app/cpu"
      type = "usage"
      unit = "%"

      mappings = {
        cpu_reserved = {
          query = "avg(kubernetes_io:container_cpu_limit_cores{${local.query_filter}})"
        }
        cpu_average = {
          query = "avg(kubernetes_io:container_cpu_request_utilization{${local.query_filter}})"
        }
        cpu_min = {
          query = "min(kubernetes_io:container_cpu_request_utilization{${local.query_filter}})"
        }
        cpu_max = {
          query = "max(kubernetes_io:container_cpu_request_utilization{${local.query_filter}})"
        }
      }
    },
    {
      name = "app/memory"
      type = "usage"
      unit = "MiB"

      mappings = {
        memory_reserved = {
          query = "avg(kubernetes_io:container_memory_request_bytes{${local.query_filter}})"
        }
        memory_average = {
          query = "avg(kubernetes_io:container_memory_used_bytes{${local.query_filter}})"
        }
        memory_min = {
          query = "min(kubernetes_io:container_memory_used_bytes{${local.query_filter}})"
        }
        memory_max = {
          query = "max(kubernetes_io:container_memory_used_bytes{${local.query_filter}})"
        }
      }
    }
  ]
}

resource "google_project_iam_member" "deployer_metrics_viewer" {
  project = local.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.deployer.email}"
}
