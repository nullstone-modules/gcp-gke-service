locals {
  // We use `local.secret_keys` to create secret resources
  // If we used `length(local.capabilities.secrets)`,
  //   terraform would complain about not knowing count of the resource until after apply
  // This is because the name of secrets isn't computed in the modules; only the secret value
  raw_secret_keys = [for secret in lookup(local.capabilities, "secrets", []) : secret["name"]]
  secret_keys     = can(nonsensitive(local.raw_secret_keys)) ? toset(nonsensitive(local.raw_secret_keys)) : toset(local.raw_secret_keys)
  cap_secrets     = { for secret in try(local.capabilities.secrets, []) : secret["name"] => secret["value"] }

  // app_secrets is prepared in the form { name => "<secret id>" , ... } for injection into kube deployment
  app_secrets = { for name in local.secret_keys : name => google_secret_manager_secret.app_secret[name].id }
}

resource "google_secret_manager_secret" "app_secret" {
  for_each = local.secret_keys

  secret_id = "${local.resource_name}/${each.value}"
  labels    = data.ns_workspace.this.tags

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
    labels = data.ns_workspace.this.tags
  }

  data = local.cap_secrets[each.value]
}
