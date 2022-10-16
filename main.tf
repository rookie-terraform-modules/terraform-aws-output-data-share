module "create_bucket" {
  count       = var.operation_mode == "create_bucket" ? 1 : 0
  source      = "./modules/create_bucket"
  bucket_name = var.bucket_name
  tags        = var.tags
}

module "export_data" {
  count              = var.operation_mode == "export_data" ? 1 : 0
  source             = "./modules/export_data"
  bucket_name        = var.bucket_name
  export_data_config = var.export_data_config
  tags               = var.tags
}

module "import_data" {
  count              = var.operation_mode == "import_data" ? 1 : 0
  source             = "./modules/import_data"
  bucket_name        = var.bucket_name
  import_data_config = var.import_data_config
  tags               = var.tags
}
