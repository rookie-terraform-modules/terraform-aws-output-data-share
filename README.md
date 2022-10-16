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
  - Access can be granted to user specified IAM groups via IAM group attachments.
- Import module outputs from a different Terraform workspace (based on your permissions).

## Usage

### **Snippet on how you create the data share bucket.**

```terraform
provider "aws" {
  region = "us-east-1"
}

module "output_data_share_bucket" {
    source = "tobeyOguney/output-data-share/aws"

    providers = {
      aws         = aws
    }

    bucket_name    = "acme-org-output-data-share"
    bucket_region  = "us-east-1"
    operation_mode = "create_bucket"
}
```

### **Snippet on how you can export outputs to the data share bucket**

```terraform
provider "aws" {
  region = "us-east-1"
}

#------------For sensitive data-----------------#

module "networking_data_exports" {
  source = "../../"

  providers = {
    aws         = aws
  }

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

  providers = {
    aws         = aws
  }

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
```

### **Snippet on how you can import outputs from the data share bucket**

```terraform
provider "aws" {
  region = "us-east-1"
}

module "team_a_merchant_app_url_import" {
    source = "tobeyOguney/output-data-share/aws"

    providers = {
      aws         = aws
    }

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

    providers = {
      aws         = aws
    }

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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.7 |

## Providers

No providers.

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the data share bucket | `string` | yes |
| <a name="input_operation_mode"></a> [operation\_mode](#input\_operation\_mode) | valid values are `create_bucket`, `export_data`, `import_data` | `string` | yes |
| <a name="input_export_data_config"></a> [export\_data\_config](#input\_export\_data\_config) | Object containing the following attributes:<br><br>  name: The name of the output group to export. (Should be unique across all workspaces)<br><br>  access\_restriction: The access restriction to apply to the exported data. Valid values are: `all_account_iam_principals` or `explicit_iam_groups`<br><br>  iam\_group\_names: List of IAM group names (Required if access\_restriction is `explicit_iam_groups`)<br><br>  data: List of objects containing the following attributes:<br>    output\_key: The key of the output to export.<br>    output\_value: The value of the output to export. | <pre>object({<br>    name               = string<br>    access_restriction = string<br>    iam_group_names    = optional(list(string))<br>    data = list(object({<br>      output_key   = string<br>      output_value = string<br>    }))<br>  })</pre> | no |
| <a name="input_import_data_config"></a> [import\_data\_config](#input\_import\_data\_config) | Object containing the following attributes:<br><br>  name: The name of the output group containing the desired import.<br><br>  access\_restriction: The access restriction of the imported data. Valid values are: `all_account_iam_principals` or `explicit_iam_groups`<br><br>  output\_key: The key of the output to import. | <pre>object({<br>    name               = string<br>    access_restriction = string<br>    output_key         = string<br>  })</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to resources. | `map(string)` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_value"></a> [value](#output\_value) | The value of the imported data. (null if `import_data_config` is not set) |
<!-- END_TF_DOCS -->
