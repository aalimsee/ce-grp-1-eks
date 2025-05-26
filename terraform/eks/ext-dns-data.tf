
# Add OIDC Provider Resource to EKS Cluster

data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

data "tls_certificate" "eks" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

data "aws_iam_openid_connect_provider" "eks" {
  url = "https://oidc.eks.us-east-1.amazonaws.com/id/B543C0746CEE9D2BDF9789C187D4A0F7"
}

# aws eks describe-cluster --name ce-grp-1-eks --query "cluster.identity.oidc.issuer" --output text
# https://oidc.eks.us-east-1.amazonaws.com/id/B543C0746CEE9D2BDF9789C187D4A0F7
# 

