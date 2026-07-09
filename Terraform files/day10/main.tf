# ==============================================================================
# Dynamic Blocks, Conditional Expressions, Splat Expressions — Day 10
# ==============================================================================

# 1. CONDITIONAL EXPRESSION (ternary) ---------------------------------------
# syntax: condition ? true_value : false_value
resource "aws_s3_bucket" "app" {
  bucket = "${var.app_name}-${var.environment}"

  tags = {
    Environment = var.environment
    # conditional: prod gets a "Production-Ready" tier, else "Non-Prod"
    Tier = var.environment == "prod" ? "Production-Ready" : "Non-Prod"
  }
}

# 2. DYNAMIC BLOCK -----------------------------------------------------------
# Repeats a nested block once per element of a collection.
resource "aws_security_group" "web" {
  name        = "${var.app_name}-sg"
  description = "SG built with dynamic ingress blocks"

  # dynamic block driven by the ingress_rules list variable
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = [ingress.value.cidr]
    }
  }

  # conditional dynamic block: only present when enable_https is true
  dynamic "ingress" {
    for_each = var.enable_https ? [443] : []
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. SPLAT EXPRESSION --------------------------------------------------------
# Creates N instances; referenced later with the [*] splat.
resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = "ami-006f82a1d5a27da54"
  instance_type = "t3.micro"

  tags = {
    Name = "${var.app_name}-web-${count.index}"
  }
}
