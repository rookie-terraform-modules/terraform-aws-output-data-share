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
variable "export_data_config" {
  type = object({
    name               = string
    access_restriction = string
    iam_group_names    = optional(list(string))
    data = list(object({
      output_key   = string
      output_value = string
    }))
  })
  default     = null
  nullable    = true
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


#--------------------import_data mode variables--------------------#

variable "import_data_config" {
  type = object({
    name               = string
    access_restriction = string
    output_key         = string
  })
  default     = null
  nullable    = true
  description = <<EOF
  Object containing the following attributes:

  name: The name of the output group containing the desired import.

  access_restriction: The access restriction of the imported data. Valid values are: all_account_iam_principals or explicit_iam_groups

  output_key: The key of the output to import.
  EOF
}
