################################################################################
# IAM Github Actions EC2 Roles
################################################################################
resource "aws_iam_role" "github_actions_ec2_role" {
  name = "github-actions-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "github_actions_ec2_policy" {
  name = "github-actions-ec2-policy"
  role = aws_iam_role.github_actions_ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "sts:AssumeRole"
      ],
      Resource = aws_iam_role.github_actions_ec2_role.arn
    }]
  })

  depends_on = [
    aws_iam_role.github_actions_ec2_role
  ]
}

################################################################################
# IAM Terraform Roles
################################################################################
resource "aws_iam_role" "terraform_ec2_role" {
  name = "terraform-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        AWS = aws_iam_role.github_actions_ec2_role.arn
      },
      Action = "sts:AssumeRole"
    }]
  })

  depends_on = [
    aws_iam_role.github_actions_ec2_role
  ]
}

resource "aws_iam_role_policy_attachment" "terraform_policy_attach" {
  role       = aws_iam_role.terraform_ec2_role.id
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  depends_on = [
    aws_iam_role.terraform_ec2_role
  ]
}

################################################################################
# Github Actions Instance
################################################################################
data "aws_subnet" "public_subnet_a" {
  vpc_id            = local.vpc_id
  availability_zone = "ap-southeast-1a"
  filter {
    name   = "tag:Type"
    values = ["Public"]
  }
}

resource "aws_iam_instance_profile" "github_actions_instance_profile" {
  name = "github-actions-instance-profile"
  role = aws_iam_role.github_actions_ec2_role.name
}

resource "aws_instance" "github_actions_instance" {
  ami                         = "ami-0e5f0fea071999cbd"
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.public_subnet_a.id
  associate_public_ip_address = true
  key_name                    = "dev-viego-ec2-keypair"
  vpc_security_group_ids      = [local.viego_whitelisted_sg_id]
  iam_instance_profile        = aws_iam_instance_profile.github_actions_instance_profile.name

  tags = {
    Name = "viego-github-actions"
  }
}

################################################################################
# IAM Role to connect OIDC to Github Actions
################################################################################
resource "aws_iam_role" "github_actions_oidc_role" {
  name = "github-actions-oidc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        },
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:${local.github_org_name}/*"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "github_actions_oidc_policy" {
  name = "github-actions-oidc-policy"
  role = aws_iam_role.github_actions_oidc_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "ec2:StartInstances",
        "ec2:StopInstances",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
      ],
      Resource = "*"
    }]
  })

  depends_on = [
    aws_iam_role.github_actions_oidc_role
  ]
}
