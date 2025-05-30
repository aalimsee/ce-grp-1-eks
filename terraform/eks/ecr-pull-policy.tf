resource "aws_iam_policy" "ecr_pull_policy" {
  name        = "ce-grp-1-ecr-readonly"
  description = "Policy to allow pulling images from Amazon ECR"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_pull_attach" {
  role       = aws_iam_role.eks_admin.name # or your node/IRSA role name
  policy_arn = aws_iam_policy.ecr_pull_policy.arn
}
