variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}

variable "bastion_sg_name" {
  description = "Security group name for the private instances"
  type        = string
}

variable "bastion_role_name" {
  description = "IAM role name for the bastion host"
  type        = string
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