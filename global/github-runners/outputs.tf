################################################################################
# Outputs for GitHub Actions Infrastructure
################################################################################

output "github_actions_ec2_role_arn" {
  description = "ARN of the GitHub Actions EC2 IAM role"
  value       = aws_iam_role.github_actions_ec2_role.arn
}

output "github_actions_ec2_role_id" {
  description = "ID of the GitHub Actions EC2 IAM role"
  value       = aws_iam_role.github_actions_ec2_role.id
}

output "github_actions_oidc_role_arn" {
  description = "ARN of the GitHub Actions OIDC IAM role"
  value       = aws_iam_role.github_actions_oidc_role.arn
}

output "github_actions_oidc_role_id" {
  description = "ID of the GitHub Actions OIDC IAM role"
  value       = aws_iam_role.github_actions_oidc_role.id
}

output "terraform_ec2_role_arn" {
  description = "ARN of the Terraform execution IAM role"
  value       = aws_iam_role.terraform_ec2_role.arn
}

output "terraform_ec2_role_id" {
  description = "ID of the Terraform execution IAM role"
  value       = aws_iam_role.terraform_ec2_role.id
}

output "github_actions_instance_id" {
  description = "EC2 instance ID of the GitHub Actions runner"
  value       = aws_instance.github_actions_instance.id
}

output "github_actions_instance_public_ip" {
  description = "Public IP address of the GitHub Actions runner instance"
  value       = aws_instance.github_actions_instance.public_ip
}

output "github_actions_instance_profile_arn" {
  description = "ARN of the GitHub Actions instance profile"
  value       = aws_iam_instance_profile.github_actions_instance_profile.arn
}
