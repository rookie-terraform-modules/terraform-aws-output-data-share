resource "aws_s3_object" "org_accessible_data_share_bucket_objects" {
  for_each = var.export_output_groups

  bucket  = var.bucket_name
  key     = "org_accessible_data/${each.value.name}.json"
  content = jsonencode({ for output in each.value.data : output.output_key => output.output_value })
}

resource "aws_s3_object" "account_accessible_data_share_bucket_objects" {
  for_each = var.export_output_groups

  bucket  = var.bucket_name
  key     = "account_accessible_data/${each.value.name}.json"
  content = jsonencode({ for output in each.value.data : output.output_key => output.output_value })
}

resource "aws_s3_object" "explicit_users_accessible_data_share_bucket_objects" {
  for_each = var.export_output_groups

  bucket  = var.bucket_name
  key     = "explicit_users_accessible_data/${each.value.name}.json"
  content = jsonencode({ for output in each.value.data : output.output_key => output.output_value })
}
