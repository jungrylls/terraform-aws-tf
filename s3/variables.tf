variable "bucket_name" {}

variable "force_destroy" {
  type    = bool
  default = true
}
variable "enable_versioning" {
  type    = bool
  default = false
}
