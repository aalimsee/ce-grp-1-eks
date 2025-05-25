data "aws_eks_cluster" "eks" {
  name = "ce-grp-1-eks"
}

data "aws_eks_cluster_auth" "eks" {
  name = data.aws_eks_cluster.eks.name
}
