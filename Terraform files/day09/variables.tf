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

variable "deploy_version" {
  type        = string
  description = "version label used for blue/green bucket naming"
  default     = "v1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "common_tags" {
  type        = map(string)
  description = "common tags merged onto resources"
  default = {
    Project = "terraform-course"
    Owner   = "devops-team"
  }
}
