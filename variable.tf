variable "region" {
  default = "ca-central-1"
}

variable "vpc_cidr" {
  default = "10.1.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.1.3.0/24", "10.1.4.0/24"]
}

variable "bucket_name" {
  default = "bucket"
}

variable "db_name" {
  default = "db"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default     = "Password123!"
  sensitive   = true
}

variable "amazon_linux_2023" {
  default = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}