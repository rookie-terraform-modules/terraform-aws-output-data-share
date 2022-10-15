output "value" {
  value = var.import_data_config.access_restriction == "all_account_iam_principals" ? local.account_accessible_output_export : local.explicit_iam_groups_accessible_output_export
}
