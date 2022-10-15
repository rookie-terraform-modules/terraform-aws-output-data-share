terraform {
  required_version = ">= 0.15"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

#------------For sensitive data-----------------#

module "networking_data_exports" {
  source = "../../"

  bucket_name    = "acme-org-output-data-share"
  bucket_region  = "us-east-1"
  operation_mode = "export_data"

  export_data_config = {
    name               = "team-a-networking-data"
    access_restriction = "explicit_iam_groups"
    iam_group_names = [
      "team_b",
      "team_c",
    ]
    data = [
      {
        output_key   = "vpc_id",
        output_value = "vpc-1234567890abcdef0"
      },
      {
        output_key   = "public_subnets_cidr_block",
        output_value = "10.0.0.0/16"
      }
    ]
  }
}

#------------For non-sensitive data---------------#

module "app_url_exports" {
  source = "../../"

  bucket_name    = "acme-org-output-data-share"
  bucket_region  = "us-east-1"
  operation_mode = "export_data"

  export_data_config = {
    name               = "team-a-app-url-data"
    access_restriction = "all_account_iam_principals"
    data = [
      {
        output_key   = "merchant_app_url",
        output_value = "https://merchant-app.acme.org"
      },
      {
        output_key   = "client_app_url",
        output_value = "https://client-app.acme.org"
      }
    ]
  }
}
