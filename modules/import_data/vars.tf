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

  name: The name of the output group to import.

  access_restriction: The access restriction of the imported data. Valid values are: all_account_iam_principals or explicit_iam_groups
  EOF
}
