terraform {
  backend "s3" {
    bucket       = "census-tfstate-012178638860"
    key          = "envs/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}