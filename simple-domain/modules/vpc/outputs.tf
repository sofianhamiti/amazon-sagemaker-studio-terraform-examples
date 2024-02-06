output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "security_group_ids" {
  value = [aws_security_group.sagemaker_sg.id]
}