data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "data_share_bucket_policy" {
  statement {
    sid = "AllowAccountAccess"

    principals {
      type        = "AWS"
      identifiers = ["*"]
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
