variable "region" {
  description = "AWS region for the state bucket"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Census Project"
  type        = string
  default     = "census-pipeline"
}
variable "environment" {
  type    = string
  default = "dev"
}