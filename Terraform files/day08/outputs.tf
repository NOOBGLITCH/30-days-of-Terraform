# ==============================================================================
# Outputs for the meta-argument demo.
# The `for` expression turns Terraform collections into new lists/maps.
# ==============================================================================

# for expression over a list of resources (count)
output "log_bucket_names" {
  description = "List of log bucket names created with count"
  value       = [for b in aws_s3_bucket.log : b.bucket]
}

# for expression over a map of resources (for_each) -> new map
output "user_bucket_arns" {
  description = "Map of user -> bucket ARN created with for_each"
  value       = { for k, b in aws_s3_bucket.user : k => b.arn }
}

# for expression over the input map with a transform (upper())
output "user_roles_upper" {
  description = "Map of user -> uppercased role, demonstrating for + upper()"
  value       = { for name, role in var.users : name => upper(role) }
}

output "env_bucket_count" {
  description = "How many env buckets were created with for_each (set)"
  value       = length(aws_s3_bucket.env)
}

output "dr_bucket_region" {
  description = "Region of the DR bucket (created via aliased provider)"
  value       = aws_s3_bucket.dr.region
}
