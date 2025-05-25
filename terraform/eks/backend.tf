terraform {
  backend "s3" {
    bucket         = "ce-grp-1-tfstate"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ce-grp-1-tf-locks"
    # encrypt        = true
  }
}
