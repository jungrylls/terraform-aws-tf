variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "bastion_sg_id" {
  type = string
}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {
  sensitive = true
}
