################################################################################
# Variables for GitHub Actions Infrastructure
################################################################################

variable "github_org_name" {
  description = "GitHub organization name for OIDC trust policy"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the GitHub Actions runner instance will be deployed"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for the public subnet lookup"
  type        = string
  default     = "ap-southeast-1a"
}

variable "instance_type" {
  description = "EC2 instance type for GitHub Actions runner"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the GitHub Actions runner instance"
  type        = string
  default     = "ami-0e5f0fea071999cbd"
}

variable "ec2_key_pair_name" {
  description = "EC2 Key Pair name for SSH access to runner instance"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for the GitHub Actions runner instance"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the GitHub Actions runner instance"
  type        = string
  default     = "github-actions-runner"
}

variable "github_actions_ec2_role_name" {
  description = "Name of the IAM role for GitHub Actions EC2"
  type        = string
  default     = "github-actions-ec2-role"
}

variable "github_actions_oidc_role_name" {
  description = "Name of the IAM role for GitHub Actions OIDC"
  type        = string
  default     = "github-actions-oidc-role"
}

variable "terraform_role_name" {
  description = "Name of the IAM role for Terraform execution"
  type        = string
  default     = "terraform-ec2-role"
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Project     = "Everfit"
  }
}
