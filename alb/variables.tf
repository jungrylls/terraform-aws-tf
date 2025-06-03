variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "target_ids" {
  type = object({
    private = list(string)
  })
}
variable "private_sg_id" {
  description = "Security group ID of the private instances"
  type        = string
}
variable "alb_sg_name" {
  description = "Security group name for the ALB"
  type        = string
}
variable "alb_tg_name" {
  description = "Target group name for the ALB"
  type        = string
}
variable "alb_name" {
  description = "Name of the ALB"
  type        = string
}