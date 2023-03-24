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
