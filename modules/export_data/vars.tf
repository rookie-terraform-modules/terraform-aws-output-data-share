variable "bucket_name" {
  type = string
}

variable "export_output_groups" {
  type = list(object({
    name               = string
    access_restriction = string
    user_arns          = list(string)
    data = list(object({
      output_key   = string
      output_value = string
    }))
  }))
  description = <<EOF
  List of objects containing the following attributes:

  name: The name of the output group to export. (Should be unique across all output groups)

  access_restriction: The access restriction to apply to the exported data. Valid values are: all_account_users, all_organization_users or explicit_users

  user_arns: List of user ARNs (Required if access_restriction is explicit_users)

  data: List of objects containing the following attributes:
    output_key: The key of the output to export.
    output_value: The value of the output to export.
  EOF
}
