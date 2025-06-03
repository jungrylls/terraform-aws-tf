output "private_sg_id" {
  value = aws_security_group.private_sg.id
}

output "instance_ids" {
  value = [for instance in aws_instance.private : instance.id]
}

output "private_instance_ips" {
  value = [for instance in aws_instance.private : instance.private_ip]
}