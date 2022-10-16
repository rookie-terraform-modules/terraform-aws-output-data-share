data "aws_iam_policy_document" "explicit_iam_groups_accessible_output_exports_share_policy_document" {
  count = var.export_data_config.access_restriction == "explicit_iam_groups" ? 1 : 0
  statement {
    sid = "AllowIAMGroupReadWriteAccess"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}/explicit_iam_groups_accessible_output_exports/${var.export_data_config.name}",
    ]
  }
}

resource "aws_iam_policy" "explicit_iam_groups_accessible_output_exports_share_policy" {
  count = var.export_data_config.access_restriction == "explicit_iam_groups" ? 1 : 0

  name        = "explicit_iam_groups_accessible_output_exports_share_policy_${var.export_data_config.name}"
  description = "Policy to allow explicit users access to ${var.export_data_config.name} output group"
  policy      = data.aws_iam_policy_document.explicit_iam_groups_accessible_output_exports_share_policy_document[0].json

  tags = var.tags
}

resource "aws_iam_group_policy_attachment" "explicit_iam_groups_accessible_output_exports_share_policy_attachments" {
  for_each = [for iam_group_name in var.export_data_config.iam_group_names : iam_group_name]

  group      = each.key
  policy_arn = aws_iam_policy.explicit_iam_groups_accessible_output_exports_share_policy[0].arn

  tags = var.tags
}
