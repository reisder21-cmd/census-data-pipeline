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

variable "github_owner" {
  description = "github user"
  type        = string
  default     = "reisder21-cmd"
}

variable "github_repo" {
  description = "repo name"
  type        = string
  default     = "census-data-pipeline"
}
variable "github_owner_id" {
  type = string
  default = "268648133"
}
variable "github_repo_id" {
  type = string
  default = "1462952614"
}