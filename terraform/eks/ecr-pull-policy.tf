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
