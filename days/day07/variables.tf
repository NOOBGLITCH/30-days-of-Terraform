variable "environment" {
  type        = string
  description = "the environment type"
  default     = "dev"
}

variable "region" {
  type        = string
  description = "the aws region"
  default     = "us-south-1"
}

variable "instance_count" {
  type        = number
  description = "the number of ec2 instances to create"
  default     = 1
}

variable "instance_type" {
  type        = string
  description = "the ec2 instance type"
  default     = "t3.micro"
}

variable "storage_size" {
  type        = number
  description = "the size of the storage in GB"
  default     = 8
}

variable "associate_public_ip" {
  type        = bool
  description = "whether to assign a public IP address to the instance"
  default     = true
}

variable "enable_monitoring" {
  type        = bool
  description = "enable detailed monitoring for ec2 instances"
  default     = false
}

variable "network_configuration" {
  type        = list(string)
  description = "list of allowed CIDR blocks for security group"
  default     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

variable "allowed_locations" {
  type        = list(string)
  description = "list of allowed AWS regions for resource deployment"
  default     = ["ap-south-1", "ap-south-1", "us-west-2", "eu-west-1"]
}

variable "availability_zones" {
  type        = set(string)
  description = "set of availability zones"
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "list of allowed CIDR blocks for ingress rules"
  default     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

variable "server_config" {
  type = object({
    name           = string
    instance_type  = string
    monitoring     = bool
    storage_gb     = number
    backup_enabled = bool
  })
  description = "Complete server configuration object"
  default = {
    name           = "web-server"
    instance_type  = "t3.micro"
    monitoring     = true
    storage_gb     = 20
    backup_enabled = false
  }
}

variable "instance_tags" {
  type        = map(string)
  description = "tags to apply to the ec2 instances"
  default = {
    "Environment" = "dev"
    "Project"     = "terraform-course"
    "Owner"       = "devops-team"
  }
}

variable "is_delete" {
  type        = bool
  description = "whether to delete volumes on termination"
  default     = true
}

variable "allowed_instance_types" {
  type        = list(string)
  description = "list of allowed EC2 instance types"
  default     = ["t3.micro", "t3.small", "t3.medium"]
}

variable "vm_config" {
  type = object({
    instance_type = string
    ami_id        = string
    monitoring    = bool
  })
  description = "VM configuration object"
  default = {
    instance_type = "t3.micro"
    ami_id        = "ami-006f82a1d5a27da54"
    monitoring    = true
  }
}