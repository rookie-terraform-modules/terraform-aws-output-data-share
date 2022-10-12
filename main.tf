module "create_bucket" {
  count       = var.operation_mode == "create_bucket" ? 1 : 0
  source      = "./modules/create_bucket"
  bucket_name = var.bucket_name
}

module "export_data" {
  count                = var.operation_mode == "export_data" ? 1 : 0
  source               = "./modules/export_data"
  bucket_name          = var.bucket_name
  export_output_groups = var.export_output_groups
}

module "import_data" {
  count                = var.operation_mode == "import_data" ? 1 : 0
  source               = "./modules/import_data"
  bucket_name          = var.bucket_name
  import_output_groups = var.import_output_groups
}
