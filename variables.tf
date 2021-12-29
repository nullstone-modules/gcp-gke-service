variable "service_image" {
  type        = string
  default     = ""
  description = <<EOF
The docker image to deploy for this service.
By default, this is blank, which means that a GCR repo is created and used.
Use this variable to configure against docker hub, quay, etc.
EOF
}

variable "service_memory" {
  type        = string
  default     = "512Mi"
  description = <<EOF
The amount of memory to reserve and cap the service.
If the service exceeds this amount, the service will be killed with exit code 127 representing "Out-of-memory".
Memory is measured in Mi, or megabytes.
This means the default is 512 Mi or 0.5 Gi.
EOF
}

variable "service_cpu" {
  type        = string
  default     = "0.5"
  description = <<EOF
The amount of CPUs to request and limit the service.
You can also specify milliCPU with a "m" suffix. For example, "0.5" equals "500m".
By default, this is set to 0.5 CPU.
EOF
}

variable "service_count" {
  type        = number
  description = "The desired number of pod replicas to run."
  default     = 1
}

variable "service_env_vars" {
  type        = map(string)
  default     = {}
  description = <<EOF
The environment variables to inject into the service.
These are typically used to configure a service per environment.
It is dangerous to put sensitive information in this variable because they are not protected and could be unintentionally exposed.
EOF
}

variable "service_port" {
  type        = number
  default     = 80
  description = <<EOF
The port that the service is listening on.
This is set to port 80 by default; however, if the service in the container is a non-root user,
the service will fail due to bind due to permission errors.
Specify 0 to disable network connectivity to this container.
EOF
}
