variable "environment" {
  type        = string
  description = "deployment environment (dev/staging/prod)"
  default     = "dev"
}

variable "bucket_base_name" {
  type        = string
  description = "prefix used to build globally unique bucket names"
  default     = "myapp"
}

variable "instance_count" {
  type        = number
  description = "number of identical log buckets to create with count"
  default     = 3
}

# Map input -> drives for_each (each.key / each.value)
variable "users" {
  type        = map(string)
  description = "map of user name -> role, used to drive for_each buckets"
  default = {
    alice = "admin"
    bob   = "read-only"
    carol = "admin"
  }
}
