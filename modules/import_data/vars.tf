variable "bucket_name" {
  type = string
}

variable "import_data_config" {
  type = object({
    name               = string
    access_restriction = string
    output_key         = string
  })
  default     = {}
  description = <<EOF
  Object containing the following attributes:

  name: The name of the output group containing the desired import.

  access_restriction: The access restriction of the imported data. Valid values are: all_account_iam_principals or explicit_iam_groups

  output_key: The key of the output to import.
  EOF
}
