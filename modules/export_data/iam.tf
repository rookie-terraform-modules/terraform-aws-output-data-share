data "aws_iam_document" "explicit_users_accessible_data_share_policy" {
  statement {
    sid = "AllowExplicitPrincipalsAccess"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/explicit_users_accessible_data/*",
    ]
  }
}

resource "aws_iam_policy" "explicit_users_accessible_data_share_policy" {
  name        = "explicit_users_accessible_data_share_policy"
  description = "Policy to allow explicit users access to data share bucket"
  policy      = data.aws_iam_document.explicit_users_accessible_data_share_policy.json
}

resource "aws_iam_user_policy_attachment" "explicit_users_accessible_data_share_policy_attachment" {
  for_each = [for group in var.export_output_groups : group if group.access_restriction == "explicit_users"]

  user       = each.value.user_arns
  policy_arn = aws_iam_policy.explicit_users_accessible_data_share_policy.arn
}
