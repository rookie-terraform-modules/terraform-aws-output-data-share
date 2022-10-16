variable "bucket_name" {
  type = string
}

variable "tags" {
  description = "A mapping of tags to assign to resources."
  type        = map(string)
  default = {
    Terraform = "true"
  }
}
