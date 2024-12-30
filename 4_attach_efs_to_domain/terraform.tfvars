# IAM
execution_role_name = "sagemaker_domain_exec_role_default"

# VPC
cidr_block           = "10.0.0.0/23"
public_subnet_cidrs  = ["10.0.0.0/25", "10.0.0.128/25"] # You can use a subnet calculator to figure cidrs
private_subnet_cidrs = ["10.0.1.0/25", "10.0.1.128/25"] # here is a good site for this https://www.davidc.net/sites/default/subnets/subnets.html
availability_zones   = ["eu-west-1a", "eu-west-1b"]

# SAGEMAKER DOMAIN
domain_name             = "sagemaker-domain"
auth_mode               = "IAM"
app_network_access_type = "VpcOnly"

# SAGEMAKER USERS
user_names = ["user1", "user2"]

# EFS
efs_folder_path   = "/shared"
lambda_mount_path = "/mnt/lambda"