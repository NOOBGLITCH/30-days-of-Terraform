# ==============================================================================

# EC2 Instance - Demonstrating all type constraints
resource "aws_instance" "web_server" {
  # String type: AMI ID and instance type
  ami           = "ami-006f82a1d5a27da54"
  instance_type = var.instance_type
  key_name      = "my-key"

  # Number type: Instance count
  count = var.instance_count

  # Bool type: Enable monitoring and public IP
  monitoring                  = var.enable_monitoring
  associate_public_ip_address = var.associate_public_ip

  # Set type: Availability zone (using first element from set)
  availability_zone = tolist(var.availability_zones)[0] # Need to convert to list to access the indices

  # List type: Security group
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Object type: Using server config object attributes
  # Note: This demonstrates object access syntax
  # instance_type could also be: var.server_config.instance_type
  # monitoring could also be: var.server_config.monitoring

  # Map type: Tags
  tags = var.instance_tags

  # Root block device using number type
  root_block_device {
    volume_size = var.storage_size
    volume_type = "gp3"
  }
}

# Security Group for EC2
resource "aws_security_group" "web_sg" {
  # String type: Name and description
  name        = "${var.server_config.name}-sg" # Object type usage
  description = "Security group for web server"

  # HTTP access using list type
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks # List type
  }

  # SSH access (from anywhere for demo)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Map type: Tags
  tags = var.instance_tags
}
