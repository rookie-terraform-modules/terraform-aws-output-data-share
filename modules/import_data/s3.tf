data "aws_s3_object" "account_accessible_data_share_bucket_objects" {
  for_each = var.import_output_groups

  bucket = var.bucket_name
  key    = "account_accessible_data/${each.value.name}"
}

data "aws_s3_object" "explicit_iam_groups_accessible_data_share_bucket_objects" {
  for_each = var.import_output_groups

  bucket = var.bucket_name
  key    = "explicit_iam_groups_accessible_data/${each.value.name}"
}

locals {
  account_accessible_import_data             = { for group in var.import_output_groups : group.name => jsondecode(data.aws_s3_object.account_accessible_data_share_bucket_objects[group.name].body) if group.access_restriction == "all_account_iam_principals" }
  explicit_iam_groups_accessible_import_data = { for group in var.import_output_groups : group.name => jsondecode(data.aws_s3_object.explicit_iam_groups_accessible_data_share_bucket_objects[group.name].body) if group.access_restriction == "explicit_iam_groups" }
  output_groups_data                         = merge(local.account_accessible_import_data, local.explicit_iam_groups_accessible_import_data)
}
