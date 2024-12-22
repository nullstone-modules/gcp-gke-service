locals {
  metrics_mappings = concat(local.base_metrics, local.cap_metrics)

  cap_metrics = []

  app_resource_metrics_filter = <<EOF
resource.type = "k8s_pod"
AND resource.labels.cluster_name = "${local.cluster_name}"
AND resource.labels.namespace_name = "${local.app_namespace}"
AND metadata.user_labels."nullstone.io/app" = "${local.app_name}"
EOF
  base_metrics = [
    {
      name = "app/cpu"
      type = "usage"
      unit = "%"

      mappings = {
        cpu_reserved = {
          project_id      = local.project_id
          metric_name     = "container.googleapis.com/container/cpu/request_cores"
          aggregation     = "sum"
          resource_filter = local.app_resource_metrics_filter
        }
        cpu_average = {
          project_id      = local.project_id
          metric_name     = "container.googleapis.com/container/cpu/usage_time"
          aggregation     = "average"
          resource_filter = local.app_resource_metrics_filter
        }
        cpu_min = {
          project_id      = local.project_id
          metric_name     = "container.googleapis.com/container/cpu/usage_time"
          aggregation     = "min"
          resource_filter = local.app_resource_metrics_filter
        }
        cpu_max = {
          project_id      = local.project_id
          metric_name     = "container.googleapis.com/container/cpu/usage_time"
          aggregation     = "max"
          resource_filter = local.app_resource_metrics_filter
        }
      }
    },
    {
      name = "app/memory"
      type = "usage"
      unit = "MiB"

      mappings = {
        memory_reserved = {
          project_id      = local.project_id
          metric_name     = "container.googleapis.com/container/memory/request_bytes"
          aggregation     = "sum"
          resource_filter = local.app_resource_metrics_filter
        }
        memory_average = {
          project_id      = local.project_id
          metric_name     = "container.googleapis.com/container/memory/bytes_used"
          aggregation     = "average"
          resource_filter = local.app_resource_metrics_filter
        }
        memory_min = {
          project_id      = local.project_id
          metric_name     = "container.googleapis.com/container/memory/bytes_used"
          aggregation     = "min"
          resource_filter = local.app_resource_metrics_filter
        }
        memory_max = {
          project_id      = local.project_id
          metric_name     = "container.googleapis.com/container/memory/bytes_used"
          aggregation     = "max"
          resource_filter = local.app_resource_metrics_filter
        }
      }
    }
  ]
}
