# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP to ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "alb-sg"
  }
}

# Ingress rule for ALB
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "Allow HTTP inbound"
}

# Egress rule to ec2 instances
resource "aws_vpc_security_group_egress_rule" "alb_http" {
  security_group_id            = aws_security_group.alb_sg.id
  referenced_security_group_id = var.private_sg_id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  description                  = "Allow HTTP outbound to private instances"
}

# Target Group
resource "aws_lb_target_group" "alb_tg" {
  name        = "tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Attach each instance to the target group
resource "aws_lb_target_group_attachment" "tg_attachments" {
  for_each = {
    for idx, id in var.target_ids.private : "${idx}" => id
  }

  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = each.value
  port             = 80
}

# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnet_ids
  enable_deletion_protection = false

  tags = {
    Name = "alb"
  }
}

# Listener for ALB
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}
