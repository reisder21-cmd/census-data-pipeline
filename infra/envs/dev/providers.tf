provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = var.project
      environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}