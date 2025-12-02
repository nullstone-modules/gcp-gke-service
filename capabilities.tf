// This file is replaced by code-generation using 'capabilities.tf.tmpl'
// This file helps app module creators define a contract for what types of capability outputs are supported.
locals {
  cap_modules = [
    {
      name       = ""
      tfId       = ""
      namespace  = ""
      env_prefix = ""
      outputs    = {}

      meta = {
        subcategory = ""
        platform    = ""
        subplatform = ""
        outputNames = []
      }
    }
  ]

  // cap_env_prefixes is a map indexed by tfId which points to the env_prefix in local.cap_modules
  cap_env_prefixes = tomap({
    x = ""
  })

  capabilities = {
    env = [
      {
        cap_tf_id = "x"
        name      = ""
        value     = ""
      }
    ]

    secrets = [
      {
        cap_tf_id = "x"
        name      = ""
        value     = sensitive("")
      }
    ]

    // private_urls follows a wonky syntax so that we can send all capability outputs into the merge module
    // Terraform requires that all members be of type list(map(any))
    // They will be flattened into list(string) when we output from this module
    private_urls = [
      {
        cap_tf_id = "x"
        url       = "http://example"
      }
    ]

    // public_urls follows a wonky syntax so that we can send all capability outputs into the merge module
    // Terraform requires that all members be of type list(map(any))
    // They will be flattened into list(string) when we output from this module
    public_urls = [
      {
        cap_tf_id = "x"
        url       = "https://example.com"
      }
    ]

    // metrics allows capabilities to attach metrics to the application
    // These metrics are displayed on the Application Monitoring page
    // See https://docs.nullstone.io/extending/metrics/overview.html
    metrics = [
      {
        cap_tf_id = "x"
        name      = ""
        type      = "usage|usage-percent|duration|generic"
        unit      = ""

        mappings = jsonencode({})
      }
    ]

    volumes = [
      {
        cap_tf_id = "x"
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
        cap_tf_id         = "x"
        name              = ""   // Required
        mount_path        = ""   // Required
        sub_path          = null // Path within the volume from which the container's volume should be mounted
        mount_propagation = null
        read_only         = null // Defaults to false
      }
    ]

    startup_probes = [
      {
        cap_tf_id             = "x"
        initial_delay_seconds = null
        period_seconds        = null
        timeout_seconds       = null
        success_threshold     = null
        failure_threshold     = null

        exec = jsonencode({
          command = []
        })
        grpc = jsonencode({
          port    = 9000
          service = "myservice"
        })
        http_get = jsonencode({
          path   = "/"
          port   = 80
          scheme = "HTTP"
        })
        tcp_socket = jsonencode({
          port = 80
        })
      }
    ]

    readiness_probes = [
      {
        cap_tf_id             = "x"
        initial_delay_seconds = null
        period_seconds        = null
        timeout_seconds       = null
        success_threshold     = null
        failure_threshold     = null

        exec = jsonencode({
          command = []
        })
        grpc = jsonencode({
          port    = 9000
          service = "myservice"
        })
        http_get = jsonencode({
          path   = "/"
          port   = 80
          scheme = "HTTP"
        })
        tcp_socket = jsonencode({
          port = 80
        })
      }
    ]

    liveness_probes = [
      {
        cap_tf_id             = "x"
        initial_delay_seconds = null
        period_seconds        = null
        timeout_seconds       = null
        success_threshold     = null
        failure_threshold     = null

        exec = jsonencode({
          command = []
        })
        grpc = jsonencode({
          port    = 9000
          service = "myservice"
        })
        http_get = jsonencode({
          path   = "/"
          port   = 80
          scheme = "HTTP"
        })
        tcp_socket = jsonencode({
          port = 80
        })
      }
    ]
  }
}
