# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name        = var.rds_sg_name
  description = "Allow DB access from bastion only"
  vpc_id      = var.vpc_id

  tags = {
    Name = "tecace-rds-sg"
  }
}

# Ingress from Bastion SG
resource "aws_vpc_security_group_ingress_rule" "rds_mysql" {
  security_group_id            = aws_security_group.rds_sg.id
  referenced_security_group_id = var.bastion_sg_id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  description                  = "Allow MySQL inbound from Bastion"
}

# DB Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = var.rds_subnet_group_name
  subnet_ids = var.subnet_ids

  tags = {
    Name = "tecace-rds-subnet-group"
  }
}

# RDS Instance
resource "aws_db_instance" "rds" {
  identifier              = "rds"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]

  tags = {
    Name = "tecace-rds"
  }
}
