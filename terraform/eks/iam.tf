resource "aws_iam_role" "eks_admin" {
  name = "ce-grp-1-eks-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        AWS = "arn:aws:iam::255945442255:user/aalimsee_ce9"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Project = "ce-grp-1"
  }
}

resource "aws_iam_role_policy" "eks_admin_policy" {
  name = "ce-grp-1-eks-admin-policy"
  role = aws_iam_role.eks_admin.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # EKS and Kubernetes API
      {
        Sid : "EKSAccess",
        Effect : "Allow",
        Action : [
          "eks:DescribeCluster",
          "eks:AccessKubernetesApi"
        ],
        Resource : "*"
      },

      # S3: Access to Terraform state
      {
        Sid : "S3StateAccess",
        Effect : "Allow",
        Action : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource : [
          "arn:aws:s3:::ce-grp-1-tfstate",
          "arn:aws:s3:::ce-grp-1-tfstate/*"
        ]
      },

      # DynamoDB: Locking
      {
        Sid : "TerraformDynamoDBLocking",
        Effect : "Allow",
        Action : [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:UpdateItem"
        ],
        Resource : "arn:aws:dynamodb:us-east-1:255945442255:table/ce-grp-1-tf-locks"
      },

      # IAM Access
      {
        Sid : "IAMAccess",
        Effect : "Allow",
        Action : [
          "iam:GetRole",
          "iam:PassRole",
          "iam:ListAttachedRolePolicies",
          "iam:GetRolePolicy",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:ListRolePolicies",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy"
        ],
        Resource : "*"
      },

      # EC2 Descriptions
      {
        Sid : "EC2Describe",
        Effect : "Allow",
        Action : [
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeTags",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSecurityGroupRules",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeImages"
        ],
        Resource : "*"
      },

      # CloudWatch Logs
      {
        Sid : "CloudWatchLogs",
        Effect : "Allow",
        Action : [
          "logs:DescribeLogGroups",
          "logs:ListTagsForResource"
        ],
        Resource : "*"
      },

      # KMS Access (can be narrowed later)
      {
        Sid : "KMSAccess",
        Effect : "Allow",
        Action : [
          "kms:GetKeyPolicy"
        ],
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "ebs_csi_custom_policy" {
  name        = "ce-grp-1-ebs-csi-policy"
  description = "Custom policy for Amazon EBS CSI driver"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:AttachVolume",
          "ec2:CreateSnapshot",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteSnapshot",
          "ec2:DeleteTags",
          "ec2:DeleteVolume",
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeAvailabilityZones",
          "ec2:DetachVolume",
          "ec2:ModifyVolume"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_custom_attach" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = aws_iam_policy.ebs_csi_custom_policy.arn
}
