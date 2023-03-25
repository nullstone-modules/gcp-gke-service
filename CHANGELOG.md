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
