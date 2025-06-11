variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "tags" {
  description = "Custom tags to apply to the security group"
  type        = map(string)
  default     = {}
}

variable "private_instance_count" {
  description = "Number of private EC2 instances to create"
  type        = number
  default     = 1
}

variable "private_sg_name" {
  description = "Security group ID for the private instances"
  type        = string
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

variable "ingress_rules" {
  description = "List of ingress rules to apply"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = optional(string)
    cidr_ipv4   = optional(string)
    sg_id       = optional(string)
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rules to apply"
  type = list(object({
    from_port   = optional(number)
    to_port     = optional(number)
    protocol    = string
    description = optional(string)
    cidr_ipv4   = optional(string)
    sg_id       = optional(string)
  }))
  default = [
    {
      protocol    = "-1"
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow all outbound"
    }
  ]
}
