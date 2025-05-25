provider "aws" {
  region = "us-east-1"
}

# Remote state to pull VPC values
# The terraform_remote_state data source only needs to read the state file — it doesn’t lock it or write to it.
# So it doesn't need DynamoDB table info (no use_lock_table, dynamodb_table, etc.).

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "ce-grp-1-tfstate"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

# EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.36.0"

  cluster_name    = "ce-grp-1-eks"
  cluster_version = "1.32"

  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true # Temporarily Enable Public Access for Testing

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    ce-grp-1-default = {
      instance_types = ["t3.medium"]
      desired_size   = 2
      min_size       = 1
      max_size       = 3
    }
  }

  authentication_mode = "API"
  #   access_entries = {
  #     eks-admin = {
  #       principal_arn       = "arn:aws:iam::255945442255:role/ce-grp-1-eks-admin-role"
  #       kubernetes_groups   = ["cluster-admins"]
  #       policy_associations = []
  #     }
  # admin-role = {
  #   principal_arn       = "arn:aws:iam::255945442255:user/aalimsee_ce9"
  #   kubernetes_groups   = ["cluster-admins"]
  #   policy_associations = []
  # }
  #   }

  tags = {
    Project = "ce-grp-1"
  }
}
