terraform {
  required_version = ">= 0.15"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

module "output_data_share_bucket" {
  source = "../../"

  bucket_name    = "acme-org-output-data-share"
  bucket_region  = "us-east-1"
  operation_mode = "create_bucket"
}
