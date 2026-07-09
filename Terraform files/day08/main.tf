# ==============================================================================
# Terraform Meta-Arguments — Day 08
#
# This project demonstrates every Terraform meta-argument:
#   count, for_each, depends_on, lifecycle, provider, and for expressions.
# ==============================================================================

# 1. count ---------------------------------------------------------------------
# Creates N identical resources. Indexed with `count.index` (0-based).
resource "aws_s3_bucket" "log" {
  count  = var.instance_count
  bucket = "${var.bucket_base_name}-log-${var.environment}-${count.index}"

  lifecycle {
    prevent_destroy = false
  }
}

# 2. for_each with a MAP -------------------------------------------------------
# One resource per map entry. `each.key` / `each.value` available.
resource "aws_s3_bucket" "user" {
  for_each = var.users
  bucket   = "${var.bucket_base_name}-${each.key}-${var.environment}"

  tags = {
    Owner = each.key
    Role  = each.value
  }
}

# 2b. for_each with a SET (convert to set first) -------------------------------
resource "aws_s3_bucket" "env" {
  for_each = toset(["dev", "staging", "prod"])
  bucket   = "${var.bucket_base_name}-env-${each.key}"
}

# 3. depends_on ----------------------------------------------------------------
# Forces an explicit ordering even when Terraform can't infer it automatically.
# Here the block must exist only after the buckets it references are created.
resource "aws_s3_bucket_public_access_block" "user_block" {
  for_each                = aws_s3_bucket.user
  bucket                  = each.value.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [aws_s3_bucket.user]
}

# 4. provider (alias) ----------------------------------------------------------
# Deploys a disaster-recovery bucket into a different region using the
# aliased provider declared in provider.tf.
resource "aws_s3_bucket" "dr" {
  provider = aws.us_east
  bucket   = "${var.bucket_base_name}-dr-${var.environment}"

  tags = {
    Region = "us-east-1"
  }
}

# 5. lifecycle -----------------------------------------------------------------
# protect a critical bucket from accidental `terraform destroy`.
resource "aws_s3_bucket" "important" {
  bucket = "${var.bucket_base_name}-important-${var.environment}"

  lifecycle {
    prevent_destroy = true
  }
}
