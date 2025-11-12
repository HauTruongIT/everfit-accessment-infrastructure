# GitHub Actions Runner Module

This Terraform module creates and configures AWS infrastructure for GitHub Actions self-hosted runners, including IAM roles, EC2 instances, and OIDC integration.

## Features

- **GitHub Actions EC2 Role:** IAM role for EC2 instances with self-assume permissions
- **GitHub Actions OIDC Role:** IAM role for GitHub Actions OIDC provider with EKS, EC2, IAM, SSM, CloudWatch, and S3 permissions
- **Terraform Execution Role:** IAM role with AdministratorAccess for Terraform operations
- **EC2 Runner Instance:** t2.micro instance in a public subnet with all necessary IAM permissions
- **Flexible Configuration:** Customizable instance type, AMI, key pair, security group, and tags

## Usage

```hcl
module "github_runners" {
  source = "../../modules/github-runners"

  github_org_name      = "HauTruongIT"
  vpc_id               = "vpc-xxxxxxxxx"
  ec2_key_pair_name    = "dev-viego-ec2-keypair"
  security_group_id    = "sg-xxxxxxxxx"

  # Optional: Override defaults
  instance_type = "t2.micro"
  ami_id        = "ami-0e5f0fea071999cbd"
  instance_name = "github-actions-runner"

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Project     = "Everfit"
    Team        = "DevOps"
  }
}
```

## Variables

| Name                              | Type          | Default                        | Required | Description                                          |
|-----------------------------------|---------------|--------------------------------|----------|------------------------------------------------------|
| `github_org_name`                 | string        | -                              | yes      | GitHub organization name for OIDC trust policy      |
| `vpc_id`                          | string        | -                              | yes      | VPC ID where runner will be deployed                |
| `ec2_key_pair_name`               | string        | -                              | yes      | EC2 Key Pair name for SSH access                    |
| `security_group_id`               | string        | -                              | yes      | Security group ID for the runner instance           |
| `availability_zone`               | string        | ap-southeast-1a               | no       | Availability zone for subnet lookup                 |
| `instance_type`                   | string        | t2.micro                      | no       | EC2 instance type                                   |
| `ami_id`                          | string        | ami-0e5f0fea071999cbd         | no       | AMI ID for the runner instance                      |
| `instance_name`                   | string        | github-actions-runner         | no       | Name tag for the runner instance                    |
| `github_actions_ec2_role_name`    | string        | github-actions-ec2-role       | no       | Name of EC2 IAM role                                |
| `github_actions_oidc_role_name`   | string        | github-actions-oidc-role      | no       | Name of OIDC IAM role                               |
| `terraform_role_name`             | string        | terraform-ec2-role            | no       | Name of Terraform execution role                    |
| `tags`                            | map(string)   | See defaults                  | no       | Common tags for all resources                       |

## Outputs

| Name                                    | Description                                    |
|----------------------------------------|------------------------------------------------|
| `github_actions_ec2_role_arn`          | ARN of the GitHub Actions EC2 IAM role        |
| `github_actions_ec2_role_id`           | ID of the GitHub Actions EC2 IAM role         |
| `github_actions_oidc_role_arn`         | ARN of the GitHub Actions OIDC IAM role       |
| `github_actions_oidc_role_id`          | ID of the GitHub Actions OIDC IAM role        |
| `terraform_ec2_role_arn`               | ARN of the Terraform execution IAM role       |
| `terraform_ec2_role_id`                | ID of the Terraform execution IAM role        |
| `github_actions_instance_id`           | EC2 instance ID of the GitHub Actions runner  |
| `github_actions_instance_public_ip`    | Public IP of the GitHub Actions runner        |
| `github_actions_instance_profile_arn`  | ARN of the GitHub Actions instance profile    |

## Prerequisites

- VPC with at least one public subnet tagged with `Type = "Public"`
- EC2 Key Pair created in the target region
- Security group with appropriate ingress/egress rules
- AWS account with permissions to create IAM roles and EC2 instances

## IAM Permissions

The module creates the following IAM roles:
- **github_actions_ec2_role:** Allows EC2 service to assume role and enables role assumption
- **github_actions_oidc_role:** Allows GitHub Actions to assume role via OIDC with permissions for EKS, EC2, IAM, SSM, CloudWatch, and S3
- **terraform_ec2_role:** Allows assumption from github_actions_ec2_role with AdministratorAccess policy

## Example

See `global/github-runners/main.tf` for a complete example of module usage.
