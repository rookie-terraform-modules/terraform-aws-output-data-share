variable "operation_mode" {
  type        = string
  description = "valid values are create_bucket, export_data, import_data"

  validation {
    condition     = can(regex("^create_bucket|export_data|import_data$", var.operation_mode))
    error_message = "The operation_mode must be either create_bucket, export_data or import_data."
  }
}

variable "bucket_region" {
  type = string
}

variable "bucket_name" {
  type = string
}


#--------------------export_data mode variables--------------------#
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
  default     = []
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


#--------------------import_data mode variables--------------------#

variable "import_output_groups" {
  type = list(object({
    name               = string
    access_restriction = string
  }))
  default     = []
  description = <<EOF
  List of objects containing the following attributes:

  name: The name of the output group to import. (Should be unique across all output groups)

  access_restriction: The access restriction of the imported data. Valid values are: all_account_users, all_organization_users or explicit_users
  EOF
}
