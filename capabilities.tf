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
        secret = jsonencode({
          secret_name  = ""   // Required - name of the k8s Secret to project
          default_mode = null // Optional - octal string (e.g. "0400")
          optional     = null // Optional
          items = [           // Optional - per-key filename/mode overrides
            {
              key  = ""
              path = ""
              mode = null
            }
          ]
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

    deployment_annotations = [
      {
        cap_tf_id = "x"
        name      = ""
        value     = ""
      }
    ]

    service_annotations = [
      {
        cap_tf_id = "x"
        name      = ""
        value     = ""
      }
    ]

    // deployment_overrides lets a capability (e.g. a load balancer) coordinate pod
    // termination with backend deprogramming for zero-downtime rollouts.
    // The app reads the first entry; null fields fall back to Kubernetes defaults.
    deployment_overrides = [
      {
        cap_tf_id                        = "x"
        pre_stop_seconds                 = null
        termination_grace_period_seconds = null
      }
    ]

    // resource_limits lets a capability merge extended resources (e.g. "nvidia.com/gpu" from a
    // GPU capability) into the main container's resources.limits. Kubernetes defaults requests
    // to match limits for extended resources.
    resource_limits = [
      {
        cap_tf_id = "x"
        name      = "nvidia.com/gpu"
        value     = "1"
      }
    ]

    // node_selectors constrain pod scheduling to nodes carrying these labels
    // (e.g. a GPU capability targeting its node pool).
    node_selectors = [
      {
        cap_tf_id = "x"
        name      = ""
        value     = ""
      }
    ]

    // tolerations allow pods to schedule onto tainted nodes (e.g. GKE's automatic
    // nvidia.com/gpu=present:NoSchedule taint on GPU node pools).
    tolerations = [
      {
        cap_tf_id          = "x"
        key                = ""
        operator           = "Equal|Exists"
        value              = null
        effect             = "NoSchedule|PreferNoSchedule|NoExecute"
        toleration_seconds = null
      }
    ]

    // topology_spread_constraints spread replicas across failure domains. The pod label
    // selector is injected by this app (match_labels); capabilities only supply the topology
    // parameters.
    topology_spread_constraints = [
      {
        cap_tf_id          = "x"
        max_skew           = 1
        topology_key       = "kubernetes.io/hostname"
        when_unsatisfiable = "DoNotSchedule|ScheduleAnyway"
      }
    ]
  }
}
