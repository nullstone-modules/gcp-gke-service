resource "google_secret_manager_secret" "app_secret" {
  for_each = data.ns_env_layout.this.managed_secret_keys

  // Valid secret_id: [[a-zA-Z_0-9]+]
  secret_id = lower(replace("${local.resource_name}_${each.value}", "/[^a-zA-Z_0-9]/", "_"))
  labels    = local.labels

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "app_secret" {
  for_each = data.ns_env_layout.this.managed_secret_keys

  secret      = google_secret_manager_secret.app_secret[each.value].id
  secret_data = data.ns_env_values.this.secrets[each.value]
}

locals {
  // all_secrets is a map of name => secret_ref in GCP secrets manager
  // This is keyed from `ns_env_layout` so that the keys are known at plan time
  all_secrets = merge(
    { for key in data.ns_env_layout.this.unmanaged_secret_keys : key => data.ns_env_values.this.unmanaged_secret_refs[key] },
    { for key, secret in google_secret_manager_secret.app_secret : key => secret.secret_id },
  )

  // Valid metadata name: [a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*
  app_secret_store_name = "${local.resource_name}-gsm-secrets"
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
      labels    = local.k8s_component_labels
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

  count = signum(length(data.ns_env_layout.this.all_secret_keys))

  manifest = {
    apiVersion = "external-secrets.io/v1"
    kind       = "ExternalSecret"

    metadata = {
      namespace = local.app_namespace
      name      = local.app_secret_store_name
      labels    = local.k8s_component_labels
    }

    spec = {
      secretStoreRef = {
        kind = "SecretStore"
        name = local.app_secret_store_name
      }
      target = {
        name = local.app_secret_store_name
      }
      data = [for key, value in local.all_secrets : {
        secretKey = key
        remoteRef = {
          key = value
        }
      }]
    }
  }
}

// The following is used to cause app redeployments when secrets change
// We do this by annotating the deployment spec with a checksum of `map { secret_key => secret_version }`
// This works because any time a secret value changes, the "latest" version changes
locals {
  secrets_checksum = sha256(jsonencode(merge(
    { for key, secret in data.google_secret_manager_secret_version.unmanaged : key => secret.version },
    { for key, secret in google_secret_manager_secret_version.app_secret : key => secret.version },
  )))
}

data "google_secret_manager_secret_version" "unmanaged" {
  for_each = data.ns_env_layout.this.unmanaged_secret_keys

  secret            = data.ns_env_values.this.unmanaged_secret_refs[each.value]
  fetch_secret_data = false
}
