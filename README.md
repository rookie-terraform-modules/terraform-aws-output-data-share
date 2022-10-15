# terraform-aws-output-data-share

[![Github Actions](https://github.com/tobeyOguney/terraform-aws-output-data-share/actions/workflows/main.yml/badge.svg)](https://github.com/tobeyOguney/terraform-aws-output-data-share/actions/workflows/main.yml)
[![Releases](https://img.shields.io/github/v/release/tobeyOguney/terraform-aws-output-data-share)](https://github.com/tobeyOguney/terraform-aws-output-data-share/releases/latest)

[Terraform Module Registry](https://registry.terraform.io/modules/tobeyOguney/remote-state-s3-backend/aws)

A Terraform module to set up secure sharing of module outputs across workspaces with fine-grained access control as an alternative to [remote state access](https://www.terraform.io/cloud-docs/workspaces/state#remote-state-access-controls).

This is a more secure approach (if you're not using Terraform Cloud workspaces) according to the [official documentation](https://www.terraform.io/language/state/remote-state-data#alternative-ways-to-share-data-between-configurations).

It introduces the concept of "output groups" - which are simply groups of your root module outputs that you'd like to have different access control settings for.

For example, there could be a group of non-sensitive outputs that you want to give every account user access to. Also, you may have another group of sensitive outputs that you only want to give specific users access to.

This is powered by an encrypted S3 bucket (SSE-S3) for storage and group policy attachments for access control.

## Features

- Create an encrypted S3 bucket to store exported module outputs.
- Export module outputs for central access with fine-grained IAM access control.
  - Access to specific outputs (seperated in a group) can be granted to all account principals (IAM users, roles)
  - Or access can be granted to user specified IAM groups via IAM group attachments.
- Import module outputs from a different Terraform workspace (based on your permissions).

## Usage

### **Snippet on how you create the data share bucket.**

```terraform
module "output_data_share_bucket" {
    source = "tobeyOguney/output-data-share/aws"

    bucket_name    = "acme-org-output-data-share"
    bucket_region  = "us-east-1"
    operation_mode = "create_bucket"
}
```

### **Snippet on how you can export outputs to the data share bucket**

```terraform

#------------For sensitive data-----------------#

module "networking_data_exports" {
    source = "tobeyOguney/output-data-share/aws"

    bucket_name    = "acme-org-output-data-share"
    bucket_region  = "us-east-1"
    operation_mode = "export_data"

    export_data_config = {
        name               = "team-a-networking-data"
        access_restriction = "explicit_iam_groups"
        iam_group_names    = [
            var.team_b_iam_group_name,
            var.team_c_iam_group_name,
        ]
        data = [
            {
                output_key   = "vpc_id",
                output_value = var.team_a_vpc_id
            },
            {
                output_key   = "public_subnets_cidr_block",
                output_value = var.team_a_public_subnets_cidr_block
            }
        ]
    }
}

#------------For non-sensitive data---------------#

module "app_url_exports" {
    source = "tobeyOguney/output-data-share/aws"

    bucket_name    = "acme-org-output-data-share"
    bucket_region  = "us-east-1"
    operation_mode = "export_data"

    export_data_config = {
        name               = "team-a-app-url-data"
        access_restriction = "all_account_iam_principals"
        data = [
            {
                output_key   = "merchant_app_url",
                output_value = var.merchant_app_url
            },
            {
                output_key   = "client_app_url",
                output_value = var.client_app_url
            }
        ]
    }
}
```

### **Snippet on how you can import outputs from the data share bucket**

```terraform
module "team_a_merchant_app_url_import" {
    source = "tobeyOguney/output-data-share/aws"

    bucket_name    = "acme-org-output-data-share"
    bucket_region  = "us-east-1"
    operation_mode = "import_data"

    import_data_config = {
        name               = "team-a-app-url-data"
        access_restriction = "all_account_iam_principals"
        output_key         = "merchant_app_url"
    }
}

module "team_a_vpc_id_import" {
    source = "tobeyOguney/output-data-share/aws"

    bucket_name    = "acme-org-output-data-share"
    bucket_region  = "us-east-1"
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
```
