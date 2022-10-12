variable "bucket_name" {
  type = string
}

variable "import_output_groups" {
  type = list(object({
    name               = string
    access_restriction = string
  }))
  description = <<EOF
  List of objects containing the following attributes:

  name: The name of the output group to import. (Should be unique across all output groups)

  access_restriction: The access restriction of the imported data. Valid values are: all_account_users, all_organization_users or explicit_users
  EOF
}
