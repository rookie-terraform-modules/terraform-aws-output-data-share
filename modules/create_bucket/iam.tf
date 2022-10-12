data "aws_organizations_organization" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "data_share_bucket_policy" {
  statement {
    sid = "AllowOrganizationAccess"

    principals {
      type        = "AWS"
      identifiers = "*"
    }

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"

      values = [
        data.aws_organizations_organization.current.id
      ]
    }

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/org_accessible_data/*",
    ]
  }

  statement {
    sid = "AllowAccountAccess"

    principals {
      type        = "AWS"
      identifiers = "*"
    }

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalAccount"

      values = [
        data.aws_caller_identity.current.account_id
      ]
    }

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:AbortMultipartUpload",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/account_accessible_data/*",
    ]
  }
}
