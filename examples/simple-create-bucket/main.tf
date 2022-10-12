terraform {
  required_version = ">= 0.15"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

module "remote_state" {
  source         = "../../"
  operation_mode = "create_bucket"
  bucket_name    = "my-terraform-state-bucket"
  bucket_region  = local.region

  providers = {
    aws = aws
  }
}
