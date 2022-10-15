data "aws_s3_object" "account_accessible_output_export_object" {
  count = var.import_data_config.access_restriction == "all_account_iam_principals" ? 1 : 0

  bucket = var.bucket_name
  key    = "account_accessible_output_exports/${var.import_data_config.name}"
}

data "aws_s3_object" "explicit_iam_groups_accessible_output_export_object" {
  count = var.import_data_config.access_restriction == "explicit_iam_groups" ? 1 : 0

  bucket = var.bucket_name
  key    = "explicit_iam_groups_accessible_output_exports/${var.import_data_config.name}"
}

locals {
  account_accessible_output_export             = lookup(try(jsondecode(data.aws_s3_object.account_accessible_output_export_object[0].body), {}), var.import_data_config.output_key, null)
  explicit_iam_groups_accessible_output_export = lookup(try(jsondecode(data.aws_s3_object.explicit_iam_groups_accessible_output_export_object[0].body), {}), var.import_data_config.output_key, null)
}
