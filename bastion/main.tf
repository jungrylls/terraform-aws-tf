// Security group for the bastion
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH and HTTP from anywhere"
  vpc_id      = var.vpc_id

  tags = {
    Name = "bastion-sg"
  }
}

// Ingress rules for the bastion host
resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv4         = "65.132.246.78/32" // Replace with a different IP address if needed
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "Allow SSH inbound"
}


// Egress rules for the bastion host
resource "aws_vpc_security_group_egress_rule" "bastion_ssh" {
  security_group_id = aws_security_group.bastion_sg.id
  referenced_security_group_id = var.private_sg_id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "Allow SSH outbound"
}
resource "aws_vpc_security_group_egress_rule" "bastion_https" {
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv4         = "0.0.0.0/0" // Replace with a different IP address if needed
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "Allow HTTPS outbound"
}

resource "aws_vpc_security_group_egress_rule" "bastion_rds" {
  security_group_id = aws_security_group.bastion_sg.id
  referenced_security_group_id = var.rds_sg_id
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
  description       = "Allow RDS outbound"
}

// IAM Role, Policy, and Instance Profile
resource "aws_iam_role" "bastion_role" {
  name = "bastion-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
  tags = {
    Name = "bastion-role"
  }
}

resource "aws_iam_role_policy_attachment" "bastion_role_policy" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "bastion-instance-profile"
  role = aws_iam_role.bastion_role.name
}

// Bastion EC2 Instance
resource "aws_instance" "bastion" {
  ami                         = var.amazon_linux_2023
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_ids[0]
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "Hello World" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "bastion"
  }
}
