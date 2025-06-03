// Security group for the private instance
resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Allow SSH from bastion host"
  vpc_id      = var.vpc_id

  tags = {
    Name = "private-sg"
  }
}

// Ingress rule for the private instance
resource "aws_vpc_security_group_ingress_rule" "private_ssh" {
  security_group_id = aws_security_group.private_sg.id
  referenced_security_group_id = var.bastion_sg_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "Allow SSH from the bastion"
}

resource "aws_vpc_security_group_ingress_rule" "private_http" {
  security_group_id = aws_security_group.private_sg.id
  referenced_security_group_id = var.alb_sg_id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "Allow HTTP inbound"
}

// Egress rule through the NAT
resource "aws_vpc_security_group_egress_rule" "private_nat" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}

// Private EC2 Instance
resource "aws_instance" "private" {
  count                  = var.private_instance_count
  ami                    = var.amazon_linux_2023
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_ids[1]
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "private-instance"
  }
}