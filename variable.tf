variable "region" {
  default = "ca-central-1"
}

variable "tags" {
  type = map(string)
  default = {
    Project     = "TecAce"
    ManagedBy   = "Terraform"
  }
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

variable "bastion_sg_name" {
  description = "Security group name for the private instances"
  default = "tecace-bastion-sg"
}
variable "bastion_role_name" {
  description = "IAM role name for the bastion host"
  default = "tecace-bastion-role"
}

variable "private_sg_name" {
  description = "Security group ID for the private instances"
  default    = "tecace-private-sg"
}

variable "alb_sg_name" {
  description = "Security group name for the ALB"
  default     = "tecace-alb-sg"
}
variable "alb_tg_name" {
  description = "Target group name for the ALB"
  default     = "tecace-alb-tg"
}
variable "alb_name" {
  description = "Name of the ALB"
  default     = "tecace-alb"
}

variable "bucket_name" {
  default = "tecace-lib-bucket"
}

variable "rds_sg_name" {
  default = "tecace-rds-sg"
}
variable "rds_subnet_group_name" {
  default = "tecace-rds-subnet-group"
}
variable "db_name" {
  default = "tecacedb"
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

