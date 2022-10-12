terraform {
  required_version = ">= 0.15"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

locals {
  region = "us-east-1"
}

provider "aws" {
  region = local.region
}

module "remote_state" {
  source         = "../../"
  operation_mode = "export_data"
  bucket_name    = "my-terraform-state-bucket"
  bucket_region  = local.region
  export_output_groups = [
    {
      name               = "my-group"
      access_restriction = "all_account_users"
      outputs = [
        {
          output_key   = "my-key"
          output_value = "my-value"
        }
      ]
    }
  ]

  providers = {
    aws = aws
  }
}
