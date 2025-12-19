# 0.8.4 (Dec 19, 2025)
* Added GOOGLE_CLOUD_PROJECT to env vars.

# 0.8.3 (Dec 17, 2025)
* Switched to using impersonation from nullstone agent to image pusher, deployer.

# 0.8.2 (Dec 02, 2025)
* Improved aggregation of capability outputs to reduce errors and improve reliability.
* Upgrade `google` terraform provider.

# 0.8.1 (Oct 22, 2025)
* Upgraded external secrets apiVersion to `external-secrets.io/v1` (was `external-secrets.io/v1beta1`).

# 0.8.0 (Sep 22, 2025)
* Upgraded terraform providers.

# 0.7.15 (Jul 08, 2025)
* Upgraded usage of secret store from v1beta1 to v1.
* Upgraded terraform providers to latest.

# 0.7.14 (Feb 06, 2025)
* Fixed configuration of startup, liveness, and readiness probes.
* Ignore changes to K8s Service `annotations` to prevent clobbering auto-generated annotations.

# 0.7.13 (Jan 24, 2025)
* Fixed bug with kubernetes secret store as a result of previous secrets fix.

# 0.7.12 (Jan 24, 2025)
* Prevent issue with dynamic calculation of secrets introduced with support for `{{ secret() }}`.

# 0.7.11 (Jan 01, 2025)
* Added support for `{{ secret(<secret-id>) }}`.

# 0.7.10 (Dec 30, 2024)
* Fixed fully-qualified private url (`.` instead of `:` between subdomain parts).

# 0.7.9 (Dec 30, 2024)
* Added `http://<service-name>:<service-port>` to private urls when `var.service_port` is specified.

# 0.7.8 (Dec 28, 2024)
* Adjusted memory metrics to output MB.
* Created consistent cpu metrics in number of cores.

# 0.7.7 (Dec 27, 2024)
* Added support for app metrics.

# 0.7.6 (Dec 17, 2024)
* Truncate image pusher service account name so it's less than max allowed of 30 characters.
* Fix deployer service account name so it's less than max allowed of 30 characters.

# 0.7.5 (Dec 09, 2024)
* Remove unnecessary permissions to read from artifact registry.

# 0.7.4 (Dec 09, 2024)
* Fix service account to read from artifact registry.

# 0.7.3 (Dec 06, 2024)
* Create unique name for artifact repo member.

# 0.7.2 (Dec 06, 2024)
* Add permissions to read the image from the artifact registry.

# 0.7.1 (Dec 06, 2024)
* Fix the repository_url

# 0.7.0 (Dec 06, 2024)
* Swapped to artifact registry repository from older container registry.
* Upgraded all providers including `google` to version 6.12.0.

# 0.6.19 (Dec 02, 2024)
* Fixed external secrets when we have no secrets.

# 0.6.18 (Dec 02, 2024)
* When we have no secrets, do not create external secrets in kubernetes.

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
