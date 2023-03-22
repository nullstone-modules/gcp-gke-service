# 0.4.0 (Unreleased)
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
