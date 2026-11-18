variable "region" {
  description = "AWS region for the state bucket"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS account profile"
  type        = string
  default     = "census-admin"
}