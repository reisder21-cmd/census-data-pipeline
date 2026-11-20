data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "tf_state" {
  bucket = "census-tfstate-${data.aws_caller_identity.current.account_id}"

  #checkov:skip=CKV_AWS_18: Single-operator project; access limited by IAM (SSO admin + read-only CI role) and versioning is enabled. 
  #checkov:skip=CKV2_AWS_62:no downstream consumers for one-person project; can revisit if alerting needs to be enabled. 
  #checkov:skip=CKV_AWS_144: Single-region portfolio project; cross-region DR not justified for rebuildable state. 
  #checkov:skip=CKV_AWS_145: SSE-S3 encryption at rest is sufficient; KMS key adds little value for non-customer data

  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_lifecycle_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    id     = "expire-old-state-versions"
    status = "Enabled"

    filter {} # empty means apply to every object in bucket

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket                  = aws_s3_bucket.tf_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}