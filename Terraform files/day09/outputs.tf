# ==============================================================================
# Outputs for the lifecycle demo, including a postcondition check.
# ==============================================================================

output "blue_green_bucket" {
  description = "Name of the blue/green deploy bucket"
  value       = aws_s3_bucket.blue_green.bucket
}

output "critical_table" {
  description = "Name of the protected DynamoDB table"
  value       = aws_dynamodb_table.critical.name
}

output "web_instance_id" {
  description = "ID of the web EC2 instance"
  value       = aws_instance.web.id
}

# 6. postcondition — validate AFTER a value is known ------------------------
output "deploy_bucket" {
  description = "Name of the deploy bucket, validated to be lowercase-safe"
  value       = aws_s3_bucket.deploy.bucket

  lifecycle {
    postcondition {
      condition     = can(regex("^[a-z0-9-]+$", aws_s3_bucket.deploy.bucket))
      error_message = "Bucket name must contain only lowercase letters, numbers, and hyphens."
    }
  }
}
