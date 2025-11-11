terraform {
  backend "s3" {
    bucket       = "viego-saas-terraform-state"
    key          = "global/github-actions/terraform.tfstate"
    region       = "ap-southeast-1"
    profile      = "aws-saas"
    use_lockfile = true
    encrypt      = true
  }
}
