# IAM role module
module "sagemaker_domain_execution_role" {
  source              = "../modules/iam"
  execution_role_name = var.execution_role_name
}

# VPC module
module "sagemaker_domain_vpc" {
  source               = "../modules/vpc"
  cidr_block           = var.cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

# EFS module
module "sagemaker_efs" {
  source             = "../modules/sagemaker_efs"
  private_subnet_ids = module.sagemaker_domain_vpc.private_subnet_ids
  security_group_ids = module.sagemaker_domain_vpc.security_group_ids
  lambda_role_arn    = module.sagemaker_domain_execution_role.role_arn
  lambda_mount_path  = var.lambda_mount_path
  efs_folder_path    = var.efs_folder_path

  depends_on = [module.sagemaker_domain_vpc, module.sagemaker_domain_execution_role]
}

# Studio Domain
# Create the SageMaker domain, associating it with the VPC, execution role, security groups, and lifecycle configuration
module "sagemaker_domain" {
  source                  = "../modules/sagemaker_domain"
  domain_name             = var.domain_name
  auth_mode               = var.auth_mode
  app_network_access_type = var.app_network_access_type
  vpc_id                  = module.sagemaker_domain_vpc.vpc_id
  subnet_ids              = module.sagemaker_domain_vpc.private_subnet_ids
  execution_role_arn      = module.sagemaker_domain_execution_role.role_arn
  security_group_ids      = module.sagemaker_domain_vpc.security_group_ids
  efs_file_system_id      = module.sagemaker_efs.efs_file_system_id
  efs_folder_path         = var.efs_folder_path
}

# Loop through list of users for creation
# Create SageMaker users for the domain, looping through a list of user names
module "sagemaker_user" {
  for_each  = { for user in var.user_names : user => user }
  source    = "../modules/sagemaker_user"
  domain_id = module.sagemaker_domain.domain_id
  user_name = each.value
}
