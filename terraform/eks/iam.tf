

resource "aws_iam_role" "eks_admin" {
  name = "ce-grp-1-eks-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::255945442255:user/aalimsee_ce9"
        },
        Action = "sts:AssumeRole"
      }
    ]
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
      {
        Sid      = "EKSDescribe"
        Effect   = "Allow"
        Action   = ["eks:DescribeCluster"]
        Resource = "*"
      },
      {
        Sid    = "DynamoDBLockTable"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:UpdateItem"
        ]
        Resource = "arn:aws:dynamodb:us-east-1:255945442255:table/ce-grp-1-tf-locks"
      },
      {
        Sid    = "S3StateAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::ce-grp-1-tfstate/eks/terraform.tfstate",
          "arn:aws:s3:::ce-grp-1-tfstate/vpc/terraform.tfstate" # Allow access to all terraform.tfstate keys in S3 (if dynamic)
        ]
      },
      {
        Sid      = "S3BucketList"
        Effect   = "Allow"
        Action   = "s3:ListBucket"
        Resource = "arn:aws:s3:::ce-grp-1-tfstate"
      },
      {
        Sid    = "IAMRoleAccess"
        Effect = "Allow"
        Action = [
          "iam:GetRole",
          "iam:PassRole",
          "iam:ListRolePolicies",
          "iam:GetRolePolicy"
        ]
        Resource = "arn:aws:iam::255945442255:role/*" # Fine-tune IAM scope (optional). If needed, you can scope this down to only the roles Terraform manages (e.g., those with prefix ce-grp-1-*), but this is OK for now.
      },
      {
        Sid      = "EC2DescribeImages"
        Effect   = "Allow"
        Action   = ["ec2:DescribeImages"]
        Resource = "*"
      },
      {
        Sid    = "CloudWatchDescribe"
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups",
          "logs:ListTagsForResource"
        ]
        Resource = "*"
      },
      {
        "Sid" : "AllowAccessKubernetesApi",
        "Effect" : "Allow",
        "Action" : [
          "eks:AccessKubernetesApi" # This is required if you use the AccessEntry API (newer EKS auth method)
        ],
        "Resource" : "*"
      }
    ]
  })
}
