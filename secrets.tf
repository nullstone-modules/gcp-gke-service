locals {
  // secret_refs is prepared in the form [{ name = "", valueFrom = "<arn>" }, ...] for injection into ECS services
  secret_refs = { for key in local.secret_keys : key => google_secret_manager_secret.app_secret[key].id }
}


resource "google_secret_manager_secret" "app_secret" {
  for_each = local.secret_keys

  secret_id = "${local.resource_name}/${each.value}"
  labels    = local.tags

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "app_secret" {
  for_each = local.secret_keys

  secret      = google_secret_manager_secret.app_secret[each.value].id
  secret_data = local.cap_secrets[each.value]
}

resource "kubernetes_secret" "app_secret" {
  for_each = local.secret_keys

  metadata {
    name   = google_secret_manager_secret.app_secret[each.key].id
    labels = local.tags
  }

  type = "Opaque"
  data = {
    value = local.cap_secrets[each.value]
  }
}
