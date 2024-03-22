locals {
  // Valid metadata name: [a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*
  app_secret_store_name = "${local.resource_name}-gsm-secrets"
}

resource "google_secret_manager_secret" "app_secret" {
  for_each = local.secret_keys

  // Valid secret_id: [[a-zA-Z_0-9]+]
  secret_id = lower(replace("${local.resource_name}_${each.value}", "/[^a-zA-Z_0-9]/", "_"))
  labels    = local.tags

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "app_secret" {
  for_each = local.secret_keys

  secret      = google_secret_manager_secret.app_secret[each.value].id
  secret_data = local.all_secrets[each.value]
}

// The secret store defines "how" to access google secrets manager
// This secret store is only responsible for establishing authentication config
resource "kubernetes_manifest" "gsm_secret_store" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
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

  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"

    metadata = {
      namespace = local.app_namespace
      name      = "${local.resource_name}-gsm-secrets"
      labels    = local.labels
    }

    spec = {
      secretStoreRef = {
        kind = "SecretStore"
        name = local.app_secret_store_name
      }
      target = {
        name = "${local.resource_name}-gsm-secrets"
      }
      data = [for key in local.secret_keys : {
        secretKey = key
        remoteRef = {
          key = google_secret_manager_secret.app_secret[key].secret_id
        }
      }]
    }
  }
}
