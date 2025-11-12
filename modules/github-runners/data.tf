################################################################################
# Data Sources for GitHub Actions Infrastructure
################################################################################

# Fetch current AWS account ID for OIDC trust policy
data "aws_caller_identity" "current" {}

# Lookup public subnet by VPC ID and availability zone
data "aws_subnet" "public_subnet_a" {
  vpc_id            = var.vpc_id
  availability_zone = var.availability_zone
  filter {
    name   = "tag:Type"
    values = ["Public"]
  }
}
