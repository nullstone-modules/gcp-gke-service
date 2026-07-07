// A PodDisruptionBudget guards against voluntary disruptions (node drains, node pool
// upgrades/swaps) evicting all replicas at once. minAvailable = replicas - 1 allows exactly
// one pod down at a time, which pairs with rolling deploys using max_unavailable = 1 and
// blocks draining the last ready replica.
// Skipped for single-replica apps: a PDB with minAvailable = 0 protects nothing, and
// minAvailable = 1 would block node drains entirely.
resource "kubernetes_pod_disruption_budget_v1" "this" {
  count = var.replicas >= 2 ? 1 : 0

  metadata {
    name      = local.app_name
    namespace = local.app_namespace
    labels    = local.k8s_component_labels
  }

  spec {
    min_available = var.replicas - 1

    selector {
      match_labels = local.match_labels
    }
  }
}
