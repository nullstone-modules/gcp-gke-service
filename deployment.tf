locals {
  main_container_name = "main"
  command             = length(var.command) > 0 ? var.command : null
}

resource "kubernetes_deployment_v1" "this" {
  #bridgecrew:skip=CKV_K8S_35: "Prefer using secrets as files over secrets as environment variables". Secrets are provided as env vars for easier integration.
  #bridgecrew:skip=CKV_K8S_43: "Image should use digest". Image digest is not available yet.
  wait_for_rollout = false

  depends_on = [kubernetes_manifest.secrets_from_gsm]

  metadata {
    name      = local.app_name
    namespace = local.app_namespace
    labels    = local.app_labels
  }

  # Pods specs
  spec {
    replicas = var.replicas

    selector {
      match_labels = local.match_labels
    }

    template {
      metadata {
        labels = local.app_labels
      }

      spec {
        restart_policy       = "Always"
        service_account_name = kubernetes_service_account_v1.app.metadata[0].name

        dynamic "volume" {
          for_each = local.volumes

          content {
            name = volume.value.name

            dynamic "empty_dir" {
              for_each = volume.value.empty_dir == null ? [] : [1]
              content {}
            }

            dynamic "persistent_volume_claim" {
              for_each = volume.value.persistent_volume_claim == null ? [] : [volume.value.persistent_volume_claim]
              iterator = pvc

              content {
                claim_name = pvc.value.claim_name
                read_only  = lookup(pvc.value, "read_only", null)
              }
            }

            dynamic "host_path" {
              for_each = volume.value.host_path == null ? [] : [volume.value.host_path]
              iterator = hp

              content {
                type = hp.value.type
                path = hp.value.path
              }
            }
          }
        }

        container {
          name  = local.main_container_name
          image = "${local.repository_url}:${local.app_version}"
          args  = local.command

          security_context {
            capabilities {
              drop = ["ALL"]
            }
          }

          resources {
            requests = {
              cpu    = var.cpu
              memory = var.memory
            }

            limits = {
              cpu    = var.cpu
              memory = var.memory
            }
          }

          dynamic "startup_probe" {
            for_each = local.startup_probes
            iterator = sp

            content {
              initial_delay_seconds = sp.value.initial_delay_seconds
              period_seconds        = sp.value.period_seconds
              timeout_seconds       = sp.value.timeout_seconds
              success_threshold     = sp.value.success_threshold
              failure_threshold     = sp.value.failure_threshold

              dynamic "exec" {
                for_each = sp.value.exec
                content {
                  command = exec.value.command
                }
              }

              dynamic "grpc" {
                for_each = sp.value.grpc
                content {
                  port    = grpc.value.port
                  service = lookup(grpc.value, "service", null)
                }
              }

              dynamic "tcp_socket" {
                for_each = sp.value.tcp_socket
                content {
                  port = tcp_socket.value.port
                }
              }

              dynamic "http_get" {
                for_each = sp.value.http_get
                content {
                  host   = lookup(http_get.value, "host", null)
                  path   = lookup(http_get.value, "path", null)
                  port   = lookup(http_get.value, "port", null)
                  scheme = lookup(http_get.value, "scheme", null)

                  dynamic "http_header" {
                    for_each = coalesce(tomap(lookup(http_get.value, "http_headers", null)), tomap({}))
                    content {
                      name  = http_header.key
                      value = http_header.value
                    }
                  }
                }
              }
            }
          }

          dynamic "readiness_probe" {
            for_each = local.readiness_probes
            iterator = sp

            content {
              initial_delay_seconds = sp.value.initial_delay_seconds
              period_seconds        = sp.value.period_seconds
              timeout_seconds       = sp.value.timeout_seconds
              success_threshold     = sp.value.success_threshold
              failure_threshold     = sp.value.failure_threshold

              dynamic "exec" {
                for_each = sp.value.exec
                content {
                  command = exec.value.command
                }
              }

              dynamic "grpc" {
                for_each = sp.value.grpc
                content {
                  port    = grpc.value.port
                  service = lookup(grpc.value, "service", null)
                }
              }

              dynamic "tcp_socket" {
                for_each = sp.value.tcp_socket
                content {
                  port = tcp_socket.value.port
                }
              }

              dynamic "http_get" {
                for_each = sp.value.http_get
                content {
                  host   = lookup(http_get.value, "host", null)
                  path   = lookup(http_get.value, "path", null)
                  port   = lookup(http_get.value, "port", null)
                  scheme = lookup(http_get.value, "scheme", null)

                  dynamic "http_header" {
                    for_each = coalesce(tomap(lookup(http_get.value, "http_headers", null)), tomap({}))
                    content {
                      name  = http_header.key
                      value = http_header.value
                    }
                  }
                }
              }
            }
          }

          dynamic "liveness_probe" {
            for_each = local.liveness_probes
            iterator = lp

            content {
              initial_delay_seconds = lp.value.initial_delay_seconds
              period_seconds        = lp.value.period_seconds
              timeout_seconds       = lp.value.timeout_seconds
              success_threshold     = lp.value.success_threshold
              failure_threshold     = lp.value.failure_threshold

              dynamic "exec" {
                for_each = lp.value.exec
                content {
                  command = exec.value.command
                }
              }

              dynamic "grpc" {
                for_each = lp.value.grpc
                content {
                  port    = grpc.value.port
                  service = lookup(grpc.value, "service", null)
                }
              }

              dynamic "tcp_socket" {
                for_each = lp.value.tcp_socket
                content {
                  port = tcp_socket.value.port
                }
              }

              dynamic "http_get" {
                for_each = lp.value.http_get
                content {
                  host   = lookup(http_get.value, "host", null)
                  path   = lookup(http_get.value, "path", null)
                  port   = lookup(http_get.value, "port", null)
                  scheme = lookup(http_get.value, "scheme", null)

                  dynamic "http_header" {
                    for_each = coalesce(tomap(lookup(http_get.value, "http_headers", null)), tomap({}))
                    content {
                      name  = http_header.key
                      value = http_header.value
                    }
                  }
                }
              }
            }
          }

          dynamic "port" {
            for_each = var.container_port > 0 ? [var.container_port] : []

            content {
              container_port = port.value
            }
          }

          dynamic "env" {
            for_each = local.all_env_vars

            content {
              name  = env.key
              value = env.value
            }
          }

          dynamic "env" {
            for_each = local.all_secret_keys

            content {
              name = env.value

              value_from {
                secret_key_ref {
                  name = local.app_secret_store_name
                  key  = env.value
                }
              }
            }
          }

          dynamic "volume_mount" {
            for_each = local.volume_mounts

            content {
              name              = volume_mount.key
              mount_path        = volume_mount.value.mount_path
              sub_path          = volume_mount.value.sub_path
              mount_propagation = volume_mount.value.mount_propagation
              read_only         = volume_mount.value.read_only
            }
          }
        }
      }
    }
  }
}
