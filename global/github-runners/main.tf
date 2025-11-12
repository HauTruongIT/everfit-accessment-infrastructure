################################################################################
# GitHub Actions Runner Configuration
# This file uses the github-runners module to provision GitHub Actions runners
################################################################################

module "github_runners" {
  source = "../../modules/github-runners"

  github_org_name      = var.github_org_name
  vpc_id               = var.vpc_id
  availability_zone    = var.availability_zone
  instance_type        = var.instance_type
  ami_id               = var.ami_id
  ec2_key_pair_name    = var.ec2_key_pair_name
  security_group_id    = var.security_group_id
  instance_name        = var.instance_name

  github_actions_ec2_role_name  = var.github_actions_ec2_role_name
  github_actions_oidc_role_name = var.github_actions_oidc_role_name
  terraform_role_name           = var.terraform_role_name

  tags = var.tags
}
