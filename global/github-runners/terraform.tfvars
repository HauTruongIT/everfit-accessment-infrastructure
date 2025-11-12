################################################################################
# Terraform Variables - Development Environment
################################################################################

# GitHub organization name for OIDC trust policy
github_org_name = "HauTruongIT"

# VPC configuration
vpc_id = "vpc-xxxxxxxxx"  # Replace with your VPC ID

# EC2 instance configuration
availability_zone      = "ap-southeast-1a"
instance_type          = "t2.micro"
ami_id                 = "ami-0e5f0fea071999cbd"
ec2_key_pair_name      = "dev-viego-ec2-keypair"      # Replace with your key pair name
security_group_id      = "sg-xxxxxxxxx"               # Replace with your security group ID
instance_name          = "github-actions-runner"

# IAM role names
github_actions_ec2_role_name  = "github-actions-ec2-role"
github_actions_oidc_role_name = "github-actions-oidc-role"
terraform_role_name           = "terraform-ec2-role"

# Common tags for all resources
tags = {
  Environment = "dev"
  ManagedBy   = "Terraform"
  Project     = "Everfit"
  Team        = "DevOps"
}
