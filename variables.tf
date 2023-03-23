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
