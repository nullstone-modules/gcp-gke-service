variable "cpu" {
  type        = string
  default     = "0.5"
  description = <<EOF
The amount of CPUs to request and limit the service.
You can also specify milliCPU with a "m" suffix. For example, "0.5" equals "500m".
By default, this is set to 0.5 CPU.
EOF
}

variable "memory" {
  type        = string
  default     = "512Mi"
  description = <<EOF
The amount of memory to reserve and cap the service.
If the service exceeds this amount, the service will be killed with exit code 127 representing "Out-of-memory".
Memory is measured in Mi, or megabytes.
This means the default is 512 Mi or 0.5 Gi.
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
