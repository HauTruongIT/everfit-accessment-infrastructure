data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    profile = "aws-saas"
    bucket  = "viego-saas-terraform-state"
    key     = "global/networking/terraform.tfstate"
    region  = "ap-southeast-1"
  }
}

data "terraform_remote_state" "prefixIP" {
  backend = "s3"

  config = {
    profile = "aws-saas"
    bucket  = "viego-saas-terraform-state"
    key     = "global/prefixIP/terraform.tfstate"
    region  = "ap-southeast-1"
  }
}

data "aws_caller_identity" "current" {}

locals {
  vpc_id                  = data.terraform_remote_state.vpc.outputs.vpc_id
  viego_whitelisted_sg_id = data.terraform_remote_state.prefixIP.outputs.viego_whitelisted_sg_id
  github_org_name         = "HauTruongIT"
}
