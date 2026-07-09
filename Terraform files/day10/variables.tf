variable "environment" {
  type        = string
  description = "deployment environment (dev/staging/prod)"
  default     = "dev"
}

variable "app_name" {
  type        = string
  description = "application name used in resource names"
  default     = "myapp"
}

variable "enable_https" {
  type        = bool
  description = "when true, add an HTTPS (443) ingress rule dynamically"
  default     = true
}

variable "instance_count" {
  type        = number
  description = "number of web EC2 instances (used by splat expressions)"
  default     = 2
}

# List of objects describing ingress rules for the dynamic block.
variable "ingress_rules" {
  type = list(object({
    port     = number
    protocol = string
    cidr     = string
  }))
  description = "ingress rules expanded by the dynamic 'ingress' block"
  default = [
    { port = 80, protocol = "tcp", cidr = "10.0.0.0/8" },
    { port = 22, protocol = "tcp", cidr = "192.168.0.0/16" }
  ]
}
