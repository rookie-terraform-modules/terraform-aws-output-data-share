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
  operation_mode = "export_data"
  bucket_name    = "my-terraform-state-bucket"
  bucket_region  = "eu-west-1"
  export_output_groups = [
    {
      name               = "my-group"
      access_restriction = "all_account_users"
      data = [
        {
          output_key   = "my-key"
          output_value = "my-value"
        }
      ]
    }
  ]
}
