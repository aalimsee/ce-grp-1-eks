provider "aws" {
  region = "us-east-1"
}

# # Force Terraform to Use v19.21.0
# terraform {
#   required_version = ">= 1.0"

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = ">= 4.57"
#     }
#     kubernetes = {
#       source  = "hashicorp/kubernetes"
#       version = ">= 2.10"
#     }
#     tls = {
#       source  = "hashicorp/tls"
#       version = ">= 3.0"
#     }
#     time = {
#       source  = "hashicorp/time"
#       version = ">= 0.9"
#     }
#   }
# }

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
  # version = "20.8.4"
  # version = "19.21.0" # ✅ Supports aws_auth_users and manage_aws_auth

  cluster_name    = "ce-grp-1-eks"
  cluster_version = "1.32"

  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true # Temporarily Enable Public Access for Testing

  eks_managed_node_groups = {
    ce-grp-1-default = {
      instance_types = ["t3.medium"]
      desired_size   = 2
      min_size       = 1
      max_size       = 3
    }
  }

  #   # authentication_mode = "API"

  #   access_entries = {
  #     admin-role = {
  #       principal_arn       = aws_iam_role.eks_admin.arn
  #       kubernetes_groups   = ["cluster-admins"]
  #       policy_associations = []
  #     }
  #   }

  authentication_mode = "API"

  access_entries = {
    admin-role = {
      principal_arn       = "arn:aws:iam::255945442255:user/aalimsee_ce9"
      kubernetes_groups   = ["cluster-admins"]
      policy_associations = []
    }
  }



  #   manage_aws_auth = true
  #   aws_auth_users = [
  #     {
  #       userarn  = "arn:aws:iam::255945442255:user/aalimsee_ce9"
  #       username = "aalimsee_ce9"
  #       groups   = ["system:masters"]
  #     },
  #   ]


  tags = {
    Project = "ce-grp-1"
  }
}
