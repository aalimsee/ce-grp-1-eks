# resource "aws_iam_user_policy" "allow_assume_eks_admin_role" {
#   name = "ce-grp-1-assume-eks-admin"
#   user = "aalimsee_ce9"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect   = "Allow",
#         Action   = "sts:AssumeRole",
#         Resource = "arn:aws:iam::255945442255:role/ce-grp-1-eks-admin-role"
#       }
#     ]
#   })
# }
