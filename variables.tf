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

variable "port" {
  type        = number
  default     = 80
  description = <<EOF
The port that the service is listening on.
This is set to port 80 by default; however, if the service in the container is a non-root user,
the service will fail due to bind due to permission errors.
Specify 0 to disable network connectivity to this container.
EOF
}

locals {
  service_port = 80
}

variable "readiness_delay" {
  type        = number
  default     = 0
  description = <<EOF
The period of time (in seconds) to delay before performing a readiness check against the application.
If an application has a long start time, readiness_delay can be used to defer readiness checks on the application.
The default value is 0.
EOF
}

