resource "aws_s3_object" "account_accessible_output_exports_object" {
  bucket  = var.bucket_name
  key     = "account_accessible_output_exports/${var.export_data_config.name}"
  content = jsonencode({ for output in var.export_data_config.data : output.output_key => output.output_value })

  tags = var.tags
}

resource "aws_s3_object" "explicit_iam_groups_accessible_output_exports_object" {
  bucket  = var.bucket_name
  key     = "explicit_iam_groups_accessible_output_exports/${var.export_data_config.name}"
  content = jsonencode({ for output in var.export_data_config.data : output.output_key => output.output_value })

  tags = var.tags
}
