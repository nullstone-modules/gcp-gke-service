// This file is replaced by code-generation using 'capabilities.tf.tmpl'
locals {
  cap_modules = [
    {
      id         = 0
      namespace  = ""
      env_prefix = ""
      outputs    = {}
    }
  ]

  cap_env_vars = {}
  cap_secrets  = {}

  capabilities = {
    env = [
      {
        name  = ""
        value = ""
      }
    ]

    secrets = [
      {
        name  = ""
        value = ""
      }
    ]

    volumes = [
      {
        name      = ""
        empty_dir = jsonencode({})
        persistent_volume_claim = jsonencode({
          claim_name = ""    // Required
          read_only  = false // Optional
        })
      }
    ]

    volume_mounts = [
      {
        name              = ""   // Required
        mount_path        = ""   // Required
        sub_path          = null // Path within the volume from which the container's volume should be mounted
        mount_propagation = null
        read_only         = null // Defaults to false
      }
    ]

    // private_urls follows a wonky syntax so that we can send all capability outputs into the merge module
    // Terraform requires that all members be of type list(map(any))
    // They will be flattened into list(string) when we output from this module
    private_urls = [
      {
        url = ""
      }
    ]

    // public_urls follows a wonky syntax so that we can send all capability outputs into the merge module
    // Terraform requires that all members be of type list(map(any))
    // They will be flattened into list(string) when we output from this module
    public_urls = [
      {
        url = ""
      }
    ]
  }
}