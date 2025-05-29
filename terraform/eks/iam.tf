

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
      },
      #   {
      #     "Sid" : "IAMListAttachedRolePolicies",
      #     "Effect" : "Allow",
      #     "Action" : [
      #       "iam:ListAttachedRolePolicies"
      #     ],
      #     "Resource" : "arn:aws:iam::255945442255:role/ce-grp-1-eks-admin-role"
      #   }
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
      },
      {
        "Sid" : "EC2Describe",
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeSecurityGroupRules",
          "ec2:DescribeInstances",
          "ec2:DescribeNetworkInterfaces"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "IAMFullReadAccess",
        "Effect" : "Allow",
        "Action" : [
          "iam:GetRole",
          "iam:ListAttachedRolePolicies",
          "iam:GetRolePolicy",
          "iam:GetPolicy"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "IAMPolicyAccess",
        "Effect" : "Allow",
        "Action" : [
          "iam:GetRole",
          "iam:ListAttachedRolePolicies",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:GetRolePolicy"
        ],
        "Resource" : "arn:aws:iam::255945442255:role/*"
      },
      {
        "Sid" : "AllowListAttachedPoliciesOnOwnRole",
        "Effect" : "Allow",
        "Action" : [
          "iam:ListAttachedRolePolicies"
        ],
        "Resource" : "arn:aws:iam::255945442255:role/ce-grp-1-eks-admin-role"
      },
      {
        Sid    = "EC2DescribeTags"
        Effect = "Allow"
        Action = [
          "ec2:DescribeTags",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeSecurityGroupRules"
        ]
        Resource = "*"
      },
      {
        Sid    = "IAMAccess"
        Effect = "Allow"
        Action = [
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:ListAttachedRolePolicies",
          "iam:GetRole",
          "iam:PassRole",
          "iam:ListRolePolicies",
          "iam:GetRolePolicy"
        ]
        Resource = "*"
      },
      {
        Sid    = "KMSAccess"
        Effect = "Allow"
        Action = [
          "kms:GetKeyPolicy"
        ]
        Resource = "*" # You can scope this down if you want
      },
      {
        Sid    = "CloudWatchLogs"
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups",
          "logs:ListTagsForResource"
        ]
        Resource = "*"
      },
      {
        Sid    = "TerraformStateAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::ce-grp-1-tfstate",
          "arn:aws:s3:::ce-grp-1-tfstate/*"
        ]
      },
      {
        Sid    = "TerraformDynamoDBLocking"
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
        Sid    = "EKSAccess"
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:AccessKubernetesApi"
        ]
        Resource = "*"
      },
      {
        "Sid" : "EC2Permissions",
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeTags",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSecurityGroupRules"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "KMSPermissions",
        "Effect" : "Allow",
        "Action" : [
          "kms:GetKeyPolicy"
        ],
        "Resource" : "*" # Or specify the exact KMS key ARN
      },
      {
        "Sid" : "IAMPolicyRead",
        "Effect" : "Allow",
        "Action" : [
          "iam:GetPolicy",
          "iam:GetPolicyVersion"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:GetRole",
          "iam:ListRolePolicies",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy"
        ],
        "Resource" : "*"
      }

    ]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_node" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEBSCSIDriverPolicy"
}
