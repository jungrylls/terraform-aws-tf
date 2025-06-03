variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}

variable "private_sg_id" {
  description = "Security group ID of the private instances"
  type        = string
}

variable "rds_sg_id" {
  type = string
}

variable "key_name" {
  description = "Name of the existing EC2 Key Pair created in AWS Console"
  type        = string
}

variable "amazon_linux_2023" {
  description = "AMI ID for Amazon Linux 2023"
  type        = string
}