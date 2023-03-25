locals {
  // secret_refs is prepared in the form [{ name = "", valueFrom = "<arn>" }, ...] for injection into ECS services
  secret_refs = { for key in local.secret_keys : key => google_secret_manager_secret.app_secret[key].id }
}

resource "google_secret_manager_secret" "app_secret" {
  for_each = local.secret_keys

  // Valid secret_id: [[a-zA-Z_0-9]+]
  secret_id = lower(replace("${local.resource_name}_${each.value}", "/[^a-zA-Z_0-9]/", "_"))
  labels    = local.tags

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "app_secret" {
  for_each = local.secret_keys

  secret      = google_secret_manager_secret.app_secret[each.value].id
  secret_data = local.all_secrets[each.value]
}

resource "kubernetes_secret" "app_secret" {
  for_each = local.secret_keys

  metadata {
    // Valid metadata name: [a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*
    name   = lower(replace("${local.resource_name}_${each.value}", "/[^a-zA-Z0-9]/", "-"))
    labels = local.labels
  }

  type = "ExternalSecret"
  data = {
    value = local.all_secrets[each.value]
  }
}
