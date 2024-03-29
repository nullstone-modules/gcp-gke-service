# 0.6.17 (Mar 29, 2024)
* Added capability support for `startupProbe`, `readinessProbe`, and `livenessProbe`.

# 0.6.16 (Mar 27, 2024)
* Fixed service name from being blank.

# 0.6.15 (Mar 27, 2024)
* Fixed capability usage of `var.service_port`.

# 0.6.14 (Mar 27, 2024)
* Added `var.service_port` to allow customization of port listening on the private network.

# 0.6.13 (Mar 27, 2024)
* Fixed more syntax mistakes with iterators on deployment volumes.

# 0.6.12 (Mar 27, 2024)
* Fixed syntax mistake with iterators on deployment volumes.

# 0.6.11 (Mar 27, 2024)
* Fixed `claim_name` to be required.

# 0.6.10 (Mar 27, 2024)
* Fixed invalid Terraform usage of `claim_name`.

# 0.6.9 (Mar 27, 2024)
* Added support for `hostPath` volumes from capabilities.
* Fixed syntax for `persistentVolumeClaim` in k8s deployment.
* Added `app_metadata["internal_subdomain"]` for capabilities.

# 0.6.8 (Mar 22, 2024)
* Fixed liveness/readiness probe (Disabled when `port=0`).

# 0.6.7 (Mar 22, 2024)
* Fix lockfile.

# 0.6.6 (Mar 22, 2024)
* Added support for `volumes` and `volume_mounts` from capabilities.
* Upgraded `google` TF provider.

# 0.6.5 (Mar 20, 2024)
* Aligning `service_port` for capabilities to port 80.

# 0.6.4 (Mar 20, 2024)
* Configured `ClusterIP` service to forward port 80 to `var.port` so that `http://<service>` resolves.

# 0.6.3 (Mar 20, 2024)
* Disable `read_only_root_filesystem`.
* Updated creation sequence to ensure secrets are created before creating the deployment.

# 0.6.2 (Jan 30, 2024)
* Use `var.readiness_delay` for liveness probe, switch to tcp liveness probe.

# 0.6.1 (Jan 30, 2024)
* Added `var.readiness_delay`, switch to tcp readiness probe.

# 0.6.0 (Aug 08, 2023)
* Added compliance scanning.
* Update `README.md` with application management info.
* Configured root file system as read-only.
* Configured requested resources.
* Dropped additional capabilities from the container.
* Configure liveness probe.

# 0.5.9 (Jun 23, 2023)
* Added optional `var.command` for overriding image CMD.

# 0.5.8 (May 06, 2023)
* Fixed issue where capability variables are generating when null.

# 0.5.7 (Apr 19, 2023)
* Fixed scheme on readiness probe.

# 0.5.6 (Apr 19, 2023)
* Fixed references to kubernetes resources.

# 0.5.5 (Apr 19, 2023)
* Fixed references to kubernetes resources.

# 0.5.4 (Apr 19, 2023)
* Added `readinessProbe` to `Service` with default values.

# 0.5.3 (Apr 19, 2023)
* Fixed `Service` to create Network Endoint Group (NEG).

# 0.5.2 (Apr 19, 2023)
* Fixed `Service` selector.

# 0.5.1 (Apr 19, 2023)
* Added `ClusterIP` `Service` that exposes `var.port` to the cluster.
* Added `service_port` and `service_name` to `app_metadata` so that capabilities know which port is exposed to the cluster.

# 0.5.0 (Mar 30, 2023)
* Moved connection from `cluster` to `cluster-namespace`.
* Moved secrets to Google Secrets Manager. 
* Configured external-secrets.io secret store to sync k8s secrets with Google Secrets Manager.
* Configured application pod with a kubernetes service account.
* Kubernetes service account has impersonation access to GCP.

# 0.4.9 (Mar 25, 2023)
* Replace `_` in Kubernetes secret name with `-` to make it valid.
* Add kubernetes recommended labels. (https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/)

# 0.4.8 (Mar 24, 2023)
* Kubernetes secret name must be lowercase.

# 0.4.7 (Mar 24, 2023)
* Changed kubernetes secret name to valid name.
 
# 0.4.6 (Mar 24, 2023)
* Ensuring GCP labels don't have uppercase characters.

# 0.4.5 (Mar 24, 2023)
* Revert labels to tags to avoid `.` and `/` which are invalid characters in GCP labels.

# 0.4.4 (Mar 24, 2023)
* Updated google secrets with a valid `secret_id`.
* Updated labels to use URI-based labels instead of tags.

# 0.4.3 (Mar 24, 2023)
* Fixed secret values stored in Google Secrets Manager.

# 0.4.2 (Mar 22, 2023)
* Use `"latest"` tag if there is no app version.

# 0.4.1 (Mar 22, 2023)
* Fix kubernetes provider host.

# 0.4.0 (Mar 22, 2023)
* Added support for environment variable interpolation.
* Renamed variables to drop `service_` prefix.
* Upgraded `capabilities.tf.tmpl` to fix various bugs with variable nil values and capability management.
* Added standard env vars: 
  - `NULLSTONE_STACK`
  - `NULLSTONE_APP`
  - `NULLSTONE_ENV`
  - `NULLSTONE_VERSION`
  - `NULLSTONE_COMMIT_SHA`
  - `NULLSTONE_PUBLIC_HOSTS`
  - `NULLSTONE_PRIVATE_HOSTS`
* Add `.terraform.lock.hcl`.
