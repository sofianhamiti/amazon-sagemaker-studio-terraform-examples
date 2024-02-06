# REGION
aws_region = "eu-west-1"

# IAM
execution_role_name = "sagemaker_domain_exec_role_default"

# VPC
cidr_block = "10.0.0.0/23"
public_subnet_cidrs = ["10.0.0.0/25", "10.0.0.128/25"]
private_subnet_cidrs = ["10.0.1.0/25", "10.0.1.128/25"]
availability_zones = ["eu-west-1a", "eu-west-1b"]

# SAGEMAKER DOMAIN
domain_name = "sagemaker-domain"
auth_mode = "IAM"
app_network_access_type = "VpcOnly"

# SAGEMAKER USERS
user_names = ["example1", "example2", "example3"]