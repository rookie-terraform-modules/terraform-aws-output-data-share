resource "aws_s3_object" "account_accessible_output_exports_share_bucket_objects" {
  for_each = [for group in var.export_data_config : group if group.access_restriction == "all_account_iam_principals"]

  bucket  = var.bucket_name
  key     = "account_accessible_output_exports/${each.value.name}"
  content = jsonencode({ for output in each.value.data : output.output_key => output.output_value })
}

resource "aws_s3_object" "explicit_iam_groups_accessible_output_exports_share_bucket_objects" {
  for_each = [for group in var.export_data_config : group if group.access_restriction == "explicit_iam_groups"]

  bucket  = var.bucket_name
  key     = "explicit_iam_groups_accessible_output_exports/${each.value.name}"
  content = jsonencode({ for output in each.value.data : output.output_key => output.output_value })
}
