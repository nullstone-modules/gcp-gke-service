variable "cpu" {
  type        = string
  default     = "0.5"
  description = <<EOF
The amount of CPU to request for the service (maps to resources.requests.cpu in the k8s deployment spec).
The k8s scheduler uses this value to decide which node to place the pod on.
You can specify CPU in cores (e.g. "0.5") or milliCPU (e.g. "500m").
By default, this is set to 0.5 CPU.
EOF
}

variable "max_cpu" {
  type        = string
  default     = ""
  description = <<EOF
The maximum amount of CPU the service can use (maps to resources.limits.cpu in the k8s deployment spec).
If the service exceeds this limit, it will be throttled.
You can specify CPU in cores (e.g. "1") or milliCPU (e.g. "1000m").
By default, this is unset which means there is no CPU limit.
EOF
}

variable "memory" {
  type        = string
  default     = "512Mi"
  description = <<EOF
The amount of memory to request for the service (maps to resources.requests.memory in the k8s deployment spec).
The k8s scheduler uses this value to decide which node to place the pod on.
Memory is measured in Mi (megabytes) or Gi (gigabytes).
By default, this is set to 512Mi (0.5Gi).
EOF
}

variable "max_memory" {
  type        = string
  default     = ""
  description = <<EOF
The maximum amount of memory the service can use (maps to resources.limits.memory in the k8s deployment spec).
If the service exceeds this limit, it will be killed with an OOMKilled status.
Memory is measured in Mi (megabytes) or Gi (gigabytes).
By default, this is unset which means there is no memory limit.
EOF
}

variable "command" {
  type        = list(string)
  default     = []
  description = <<EOF
This overrides the `CMD` specified in the image.
Specify a blank list to use the image's `CMD`.
Each token in the command is an item in the list.
For example, `echo "Hello World"` would be represented as ["echo", "\"Hello World\""].
EOF
}

variable "replicas" {
  type        = number
  description = "The desired number of pod replicas to run."
  default     = 1
}

variable "container_port" {
  type        = number
  default     = 8080
  description = <<EOF
This is the port that your container is listening and will get mapped to var.service_port for external communication.
By default, this is set to 8080.
You cannot bind to a port <1024 a you will get permission errors.
EOF
}

variable "service_port" {
  type        = number
  default     = 80
  description = <<EOF
Other services on the network can reach this app via `<app_name>:<service_port>`.
`service_port` is mapped to `container_port`.
Specify 0 to disable network connectivity to this app.
EOF
}

variable "backend_policy" {
  type = object({
    timeout_sec = optional(number, 30)
    connection_draining = optional(object({
      timeout_sec = optional(number, 0)
    }))
    session_affinity = optional(object({
      type           = optional(string, "NONE")
      cookie_ttl_sec = optional(number, 0)
    }))
    logging = optional(object({
      enabled     = optional(bool, true)
      sample_rate = optional(number, 1000000)
    }), { enabled = true })
  })
  default     = {}
  description = "GCP backend policy configuration for the load balancer. Controls timeout, connection draining, session affinity, and access logging."
}

variable "rolling_update_strategy" {
  type = object({
    max_surge       = optional(string)
    max_unavailable = optional(string)
  })
  default = {
    max_surge       = "1"
    max_unavailable = "0"
  }
  description = <<EOF
The rolling update strategy for the Deployment.
The defaults (`max_surge = "1"`, `max_unavailable = "0"`) guarantee no reduction in serving capacity during a rollout, which (together with an attached Load Balancer's termination coordination) enables zero-downtime deploys.
Set to `null` to omit the strategy and use the Kubernetes default (25% surge / 25% unavailable).
EOF
}

variable "termination_grace_seconds" {
  type        = number
  default     = 30
  description = <<EOF
The number of seconds Kubernetes waits after SIGTERM for the pod to shut down gracefully before force-killing it.
Increase for apps that need to finish in-flight work on shutdown (e.g. model servers draining long-running requests).
When an attached capability (e.g. a load balancer) supplies its own termination grace override, the larger of the two values is used.
By default, this is set to 30 (the Kubernetes default).
EOF
}

variable "image_url" {
  type    = string
  default = ""

  description = <<EOF
This allows you to override the image used for the application.
This removes management of build artifacts through Nullstone, but allows you to use pre-built artifacts managed externally.

If blank, Nullstone will create an image repository and provide management of images.

If you configure image_url, you can still use `nullstone deploy --version=<...>` to deploy a specific image tag.
EOF
}
