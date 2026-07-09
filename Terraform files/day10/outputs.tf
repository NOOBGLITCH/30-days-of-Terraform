# ==============================================================================
# Outputs demonstrating SPLAT expressions and conditional results.
# ==============================================================================

# Splat: aws_instance.web is a list (because of count), so [*] extracts
# the .id attribute from every element into a single list.
output "instance_ids" {
  description = "List of all web instance IDs"
  value       = aws_instance.web[*].id
}

output "instance_public_ips" {
  description = "List of all web instance public IPs"
  value       = aws_instance.web[*].public_ip
}

output "instance_private_ips" {
  description = "List of all web instance private IPs"
  value       = aws_instance.web[*].private_ip
}

# Conditional expression inside an output value.
output "tier_label" {
  description = "Tier label derived from the environment"
  value       = var.environment == "prod" ? "Production-Ready" : "Non-Prod"
}

output "https_enabled" {
  description = "Whether the HTTPS ingress rule was created"
  value       = var.enable_https
}
