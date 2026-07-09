# ==============================================================================
# Terraform Lifecycle Meta-Arguments — Day 09
#
# Demonstrates:
#   create_before_destroy, prevent_destroy, ignore_changes,
#   replace_triggered_by, precondition, postcondition
# ==============================================================================

# 1. create_before_destroy — zero-downtime (blue/green) deployments ----------
# Terraform creates the replacement BEFORE destroying the old one.
# Most useful with count/for_each; shown here on a single blue/green bucket.
resource "aws_s3_bucket" "blue_green" {
  bucket = "${var.app_name}-${var.environment}-${var.deploy_version}"

  lifecycle {
    create_before_destroy = true
  }
}

# 2. prevent_destroy — protect critical resources ---------------------------
# terraform destroy / replace will ERROR instead of deleting this table.
resource "aws_dynamodb_table" "critical" {
  name         = "${var.app_name}-table-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# 3. ignore_changes — ignore external / managed-field updates ---------------
# Changes to tags made outside Terraform (or by other tooling) are ignored.
resource "aws_instance" "web" {
  ami           = "ami-006f82a1d5a27da54"
  instance_type = var.instance_type

  tags = merge(var.common_tags, {
    Name = "${var.app_name}-web"
  })

  lifecycle {
    ignore_changes = [tags]
  }
}

# 4. replace_triggered_by — replace when another resource changes -----------
# If the EC2 instance is replaced, this security group is replaced too,
# keeping the pair consistent.
resource "aws_security_group" "web_sg" {
  name        = "${var.app_name}-sg"
  description = "Security group tied to the web instance lifecycle"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    replace_triggered_by = [aws_instance.web]
  }
}

# 5. precondition — validate BEFORE creating the resource -------------------
resource "aws_s3_bucket" "deploy" {
  bucket = "${var.app_name}-deploy-${var.environment}"

  lifecycle {
    precondition {
      condition     = length(var.environment) > 0
      error_message = "The environment variable must not be empty."
    }
  }
}
