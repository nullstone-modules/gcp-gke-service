variable "service_image" {
  type        = string
  description = "Service container image url."
  default     = ""
}

variable "service_memory" {
  type        = string
  description = "Allocated memory to pods."
  default     = "512Mi"
}

variable "service_cpu" {
  type        = string
  description = "Allocated cpu to pods."
  default     = "0.5"
}

variable "service_count" {
  type        = number
  description = "The number of desired pods replicas."
  default     = 1
}

variable "service_port" {
  type        = number
  description = "The port that will be exposed by this service."
  default     = 80
}

variable "lb_port" {
  type        = number
  description = "The port to access on the pods targeted by the service."
  default     = 80
}

variable "enable_lb" {
  type        = bool
  default     = true
  description = "Enable this to add a load balancer service."
}
