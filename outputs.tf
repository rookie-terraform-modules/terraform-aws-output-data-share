output "value" {
  value       = try(module.import_data[0].value, null)
  description = "The value of the imported data. (null if `import_data_config` is not set)"
  sensitive   = true
}
