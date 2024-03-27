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
Set your container to listen on this port.
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

variable "readiness_delay" {
  type        = number
  default     = 0
  description = <<EOF
The period of time (in seconds) to delay before performing a readiness check against the application.
If an application has a long start time, readiness_delay can be used to defer readiness checks on the application.
The default value is 0.
EOF
}

