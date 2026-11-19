output "state_bucket_name" {
  description = "Name of the Terraform state bucket"
  value       = aws_s3_bucket.tf_state.bucket
}
output "github_plan_role_arn" {
  description = "IAM role ARN that GitHub Actions assumes for terraform plan"
  value       = aws_iam_role.github_plan.arn
}