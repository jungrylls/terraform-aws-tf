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
