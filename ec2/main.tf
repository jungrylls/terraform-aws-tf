// Security group for the private instance
resource "aws_security_group" "private_sg" {
  name        = var.private_sg_name
  description = "Allow SSH from bastion host"
  vpc_id      = var.vpc_id

  tags = var.tags
  
}

resource "aws_vpc_security_group_ingress_rule" "custom_ingress" {
  for_each = {
    for idx, rule in var.ingress_rules :
    idx => rule
  }

  security_group_id = aws_security_group.private_sg.id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  description       = lookup(each.value, "description", null)

  cidr_ipv4                 = lookup(each.value, "cidr_ipv4", null)
  referenced_security_group_id = lookup(each.value, "sg_id", null)
}

resource "aws_vpc_security_group_egress_rule" "custom_egress" {
  for_each = {
    for idx, rule in var.egress_rules :
    idx => rule
  }

  security_group_id = aws_security_group.private_sg.id
  from_port         = lookup(each.value, "from_port", null)
  to_port           = lookup(each.value, "to_port", null)
  ip_protocol       = each.value.protocol
  description       = lookup(each.value, "description", null)

  cidr_ipv4                 = lookup(each.value, "cidr_ipv4", null)
  referenced_security_group_id = lookup(each.value, "sg_id", null)
}

// Private EC2 Instance
resource "aws_instance" "private" {
  count                  = var.private_instance_count
  ami                    = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "tecace-private-instance"
  }
}