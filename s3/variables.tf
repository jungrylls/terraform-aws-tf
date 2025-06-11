variable "bucket_name" {
  type        = string  # Added type
  description = "The name of the S3 bucket (must be globally unique)."
}

variable "force_destroy" {
  type        = bool
  default     = true
  description = "Whether to allow the bucket to be destroyed even if it contains objects."
}

variable "enable_versioning" {
  type        = bool
  default     = false
  description = "Whether to enable versioning on the S3 bucket."
}