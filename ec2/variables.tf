variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}

variable "private_instance_count" {
  description = "Number of private EC2 instances to create"
  type        = number
  default     = 2
}

variable "alb_sg_id" {
  type = string
}

variable "bastion_sg_id" {
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