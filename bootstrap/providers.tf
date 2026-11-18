provider "aws" {
  region  = var.region
  profile = var.aws_profile

  default_tags {
    tags = {
      Project   = "census-pipeline"
      ManagedBy = "Terraform"
      Component = "bootstrap"
    }
  }
}