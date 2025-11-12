################################################################################
# IAM GitHub Actions EC2 Roles
################################################################################
resource "aws_iam_role" "github_actions_ec2_role" {
  name = var.github_actions_ec2_role_name

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
  name = var.terraform_role_name

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
# GitHub Actions Instance
################################################################################
resource "aws_iam_instance_profile" "github_actions_instance_profile" {
  name = "github-actions-instance-profile"
  role = aws_iam_role.github_actions_ec2_role.name

  tags = merge(
    var.tags,
    {
      Name = "github-actions-instance-profile"
    }
  )
}

resource "aws_instance" "github_actions_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.public_subnet_a.id
  associate_public_ip_address = true
  key_name                    = var.ec2_key_pair_name
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = aws_iam_instance_profile.github_actions_instance_profile.name

  tags = merge(
    var.tags,
    {
      Name = var.instance_name
    }
  )
}

################################################################################
# IAM Role to connect OIDC to Github Actions
################################################################################
resource "aws_iam_role" "github_actions_oidc_role" {
  name = var.github_actions_oidc_role_name

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
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:ListNodegroups",
          "eks:DescribeNodegroup",
          "eks:AccessKubernetesApi",
          "eks:ListUpdates",
          "eks:DescribeUpdate"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs",
          "ec2:DescribeRouteTables",
          "ec2:DescribeNetworkInterfaces"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "iam:ListRoles",
          "iam:GetRole",
          "iam:PassRole"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ],
        Resource = "*"
      }
    ]
  })

  depends_on = [
    aws_iam_role.github_actions_oidc_role
  ]
}
