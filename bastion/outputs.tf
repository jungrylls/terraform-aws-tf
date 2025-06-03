output "bastion_id" {
    value = aws_instance.bastion.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "bastion_public_ip" {
  description = "Public IP of the bastion EC2 instance"
  value       = aws_instance.bastion.public_ip
}