data "aws_s3_object" "org_accessible_data_share_bucket_objects" {
  for_each = var.import_output_groups

  bucket = var.bucket_name
  key    = "org_accessible_data/${each.value.name}.json"
}

data "aws_s3_object" "account_accessible_data_share_bucket_objects" {
  for_each = var.import_output_groups

  bucket = var.bucket_name
  key    = "account_accessible_data/${each.value.name}.json"
}

data "aws_s3_object" "explicit_users_accessible_data_share_bucket_objects" {
  for_each = var.import_output_groups

  bucket = var.bucket_name
  key    = "explicit_users_accessible_data/${each.value.name}.json"
}

locals {
  org_accessible_import_data            = { for group in var.import_output_groups : group.name => jsondecode(data.aws_s3_object.org_accessible_data_share_bucket_objects[group.name].body) if group.access_restriction == "all_organization_users" }
  account_accessible_import_data        = { for group in var.import_output_groups : group.name => jsondecode(data.aws_s3_object.account_accessible_data_share_bucket_objects[group.name].body) if group.access_restriction == "all_account_users" }
  explicit_users_accessible_import_data = { for group in var.import_output_groups : group.name => jsondecode(data.aws_s3_object.explicit_users_accessible_data_share_bucket_objects[group.name].body) if group.access_restriction == "explicit_users" }
  output_groups_data                    = merge(local.org_accessible_import_data, local.account_accessible_import_data, local.explicit_users_accessible_import_data)
}
