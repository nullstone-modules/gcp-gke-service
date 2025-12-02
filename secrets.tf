// "existing" adds support for the `secret(...)` syntax
// This only supports `secret(...)` specified by the user
data "ns_env_variables" "existing" {
  input_env_variables = var.env_vars
  input_secrets       = {}
}

locals {
  base_secret_keys     = data.ns_secret_keys.this.secret_keys
  existing_secret_keys = keys(data.ns_env_variables.existing.secret_refs)
  all_secret_keys      = toset(concat(tolist(local.base_secret_keys), local.existing_secret_keys))
}

resource "google_secret_manager_secret" "app_secret" {
  for_each = local.base_secret_keys

  // Valid secret_id: [[a-zA-Z_0-9]+]
  secret_id = lower(replace("${local.resource_name}_${each.value}", "/[^a-zA-Z_0-9]/", "_"))
  labels    = local.tags

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "app_secret" {
  for_each = local.base_secret_keys

  secret      = google_secret_manager_secret.app_secret[each.value].id
  secret_data = local.all_secrets[each.value]
}

locals {
  // Valid metadata name: [a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*
  app_secret_store_name = "${local.resource_name}-gsm-secrets"

  // secret refs are prepared as a map in the form name:"<secret-id>"
  // base => user-injected + capability secrets
  // existing => user-injected with format `secret(...)`
  base_secret_refs = { for key in local.base_secret_keys : key => google_secret_manager_secret.app_secret[key].secret_id }
  all_secret_refs  = merge(local.base_secret_refs, local.existing_secret_refs)
}

// The secret store defines "how" to access google secrets manager
// This secret store is only responsible for establishing authentication config
resource "kubernetes_manifest" "gsm_secret_store" {
  manifest = {
    apiVersion = "external-secrets.io/v1"
    kind       = "SecretStore"

    metadata = {
      namespace = local.app_namespace
      name      = local.app_secret_store_name
      labels    = local.labels
    }

    spec = {
      provider = {
        gcpsm = {
          projectID = local.project_id

          auth = {
            workloadIdentity = {
              clusterLocation = local.region
              clusterName     = local.cluster_name
              serviceAccountRef = {
                name = kubernetes_service_account_v1.app.metadata.0.name
              }
            }
          }
        }
      }
    }
  }
}

// The `ExternalSecret` resource creates a single k8s Secret
// with all secrets from capabilities and `secrets` var for this application pod
// Each `key` in this secret maps directly to an env var to inject into the app pod
resource "kubernetes_manifest" "secrets_from_gsm" {
  depends_on = [kubernetes_manifest.gsm_secret_store]

  count = signum(length(local.all_secret_keys))

  manifest = {
    apiVersion = "external-secrets.io/v1"
    kind       = "ExternalSecret"

    metadata = {
      namespace = local.app_namespace
      name      = local.app_secret_store_name
      labels    = local.labels
    }

    spec = {
      secretStoreRef = {
        kind = "SecretStore"
        name = local.app_secret_store_name
      }
      target = {
        name = local.app_secret_store_name
      }
      data = [for key, value in local.all_secret_refs : {
        secretKey = key
        remoteRef = {
          key = value
        }
      }]
    }
  }
}
