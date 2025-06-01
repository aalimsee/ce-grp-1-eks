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
# Accepts your EKS OIDC provider URL and ARN as variables

variable "oidc_provider_url" {
  description = "EKS cluster OIDC provider URL"
  type        = string
}

variable "oidc_provider_arn" {
  description = "EKS cluster OIDC provider ARN"
  type        = string
}
# --- end