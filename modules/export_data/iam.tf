locals {
  iam_group_mapping_list = flatten([
    for output_group in var.export_output_groups : [
      for iam_group_name in output_group.iam_group_names :
      {
        iam_group_name    = iam_group_name
        output_group_name = output_group.name
      }
    ] if output_group.access_restriction == "explicit_iam_groups"
  ])
}

data "aws_iam_policy_document" "explicit_iam_groups_accessible_data_share_policies" {
  for_each = [for group in var.export_output_groups : group.name if group.access_restriction == "explicit_iam_groups"]
  statement {
    sid = "AllowExplicitPrincipalsAccess"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}/explicit_iam_groups_accessible_data/${each.value}",
    ]
  }
}

resource "aws_iam_policy" "explicit_iam_groups_accessible_data_share_policies" {
  for_each = [for group in var.export_output_groups : group.name if group.access_restriction == "explicit_iam_groups"]

  name        = "explicit_iam_groups_accessible_data_share_policy_${each.value}"
  description = "Policy to allow explicit users access to ${each.value} data"
  policy      = data.aws_iam_policy_document.explicit_iam_groups_accessible_data_share_policies[each.value].json
}

resource "aws_iam_group_policy_attachment" "explicit_iam_groups_accessible_data_share_policy_attachments" {
  for_each = local.iam_group_mapping_list

  group      = each.value.iam_group_name
  policy_arn = aws_iam_policy.explicit_iam_groups_accessible_data_share_policies[each.value.output_group_name].arn
}
