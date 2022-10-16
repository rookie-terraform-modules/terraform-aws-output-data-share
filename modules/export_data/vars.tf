variable "bucket_name" {
  type = string
}

variable "export_data_config" {
  type = object({
    name               = string
    access_restriction = string
    iam_group_names    = list(string)
    data = list(object({
      output_key   = string
      output_value = string
    }))
  })
  description = <<EOF
  Object containing the following attributes:

  name: The name of the output group to export. (Should be unique across all workspaces)

  access_restriction: The access restriction to apply to the exported data. Valid values are: all_account_iam_principals or explicit_iam_groups

  iam_group_names: List of IAM group names (Required if access_restriction is explicit_iam_groups)

  data: List of objects containing the following attributes:
    output_key: The key of the output to export.
    output_value: The value of the output to export.
  EOF
}

variable "tags" {
  description = "A mapping of tags to assign to resources."
  type        = map(string)
  default = {
    Terraform = "true"
  }
}
