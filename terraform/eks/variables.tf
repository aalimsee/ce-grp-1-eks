# No longer needed because we use terraform_remote_state
# variable "vpc_id" { ... }
# variable "private_subnet_ids" { ... }

# variable "vpc_id" {
#   description = "VPC ID"
#   type        = string
# }

# variable "private_subnet_ids" {
#   description = "List of private subnet IDs"
#   type        = list(string)
# }


# --- start
# Accepts your EKS OIDC provider URL and ARN as variables. Setup for Prometheus and Grafana.

variable "oidc_provider_url" {
  description = "EKS cluster OIDC provider URL"
  type        = string
  default     = "https://oidc.eks.us-east-1.amazonaws.com/id/B543C0746CEE9D2BDF9789C187D4A0F7"
}

variable "oidc_provider_arn" {
  description = "EKS cluster OIDC provider ARN"
  type        = string
  default     = "arn:aws:iam::255945442255:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/B543C0746CEE9D2BDF9789C187D4A0F7"
}
# --- end