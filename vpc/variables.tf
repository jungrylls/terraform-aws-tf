variable "vpc_cidr" {}
variable "region" {
  description = "AWS region where the VPC will be created"
  type        = string
}
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
