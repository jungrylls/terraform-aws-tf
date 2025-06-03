output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_dns" {
  value = module.alb.lb_dns_name
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "s3_bucket" {
  value = module.s3.bucket_name
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion host for SSH access"
  value       = module.bastion.bastion_public_ip
}

output "private_instance_ip" {
  description = "Private IP address of the private instance"
  value       = module.ec2.private_instance_ips
}

output "agent" {
  value = "eval $(ssh-agent -s)"
}

output "agent_add" {
  description = "Add the private key to the SSH agent"
  value       = "ssh-add ~/.ssh/moon-onboarding.pem"
}

output "ssh_command" {
  description = "SSH command to access the bastion (assumes your private key is moon-onboarding.pem)"
  value       = "ssh -A ec2-user@${module.bastion.bastion_public_ip}"
}

output "private_ssh_command" {
  description = "SSH command to access the private instance (assumes your private key is moon-onboarding.pem)"
  value       = [
    for ip in module.ec2.private_instance_ips : "ssh -A ec2-user@${ip}"
  ]
}