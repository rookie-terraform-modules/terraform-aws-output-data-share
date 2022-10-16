terraform {
  required_version = ">= 0.15"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "team_a_merchant_app_url_import" {
  source = "../../"

  providers = {
    aws = aws
  }

  bucket_name    = "acme-org-output-data-share"
  operation_mode = "import_data"

  import_data_config = {
    name               = "team-a-app-url-data"
    access_restriction = "all_account_iam_principals"
    output_key         = "merchant_app_url"
  }
}

module "team_a_vpc_id_import" {
  source = "../../"

  providers = {
    aws = aws
  }

  bucket_name    = "acme-org-output-data-share"
  operation_mode = "import_data"

  import_data_config = {
    name               = "team-a-networking-data"
    access_restriction = "explicit_iam_groups"
    output_key         = "vpc_id"
  }
}

locals {
  vpc_id  = module.team_a_vpc_id_import.value
  app_url = module.team_a_merchant_app_url_import.value
}
