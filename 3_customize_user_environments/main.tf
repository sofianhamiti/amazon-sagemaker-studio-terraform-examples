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

# Customize the environment for users using lifecycle configs
module "jupyterlab_config" {
  source            = "../modules/sagemaker_lifecycle_config"
  lcc_name          = var.lcc_name_jupyterlab
  lcc_config_script = var.lcc_script_jupyterlab
  app_type          = "JupyterLab" # 'CodeEditor' or 'JupyterLab'
}

module "vscode_config" {
  source            = "../modules/sagemaker_lifecycle_config"
  lcc_name          = var.lcc_name_vscode
  lcc_config_script = var.lcc_script_vscode
  app_type          = "CodeEditor" # 'CodeEditor' or 'JupyterLab'
}


# Customize the environment for users using custom container images
# module "custom_container_image" {
#   source         = "../modules/sagemaker_custom_image"
#   image_name     = var.image_name
#   execution_role = module.sagemaker_domain_execution_role.role_arn
# }


# Studio Domain
# Create the SageMaker domain, associating it with the VPC, execution role, security groups, and lifecycle configuration
module "sagemaker_domain" {
  source                           = "../modules/sagemaker_domain"
  domain_name                      = var.domain_name
  auth_mode                        = var.auth_mode
  app_network_access_type          = var.app_network_access_type
  vpc_id                           = module.sagemaker_domain_vpc.vpc_id
  subnet_ids                       = module.sagemaker_domain_vpc.private_subnet_ids
  execution_role_arn               = module.sagemaker_domain_execution_role.role_arn
  security_group_ids               = module.sagemaker_domain_vpc.security_group_ids
  jupyterlab_lifecycle_config_arns = [module.jupyterlab_config.config_arn]
  vscode_lifecycle_config_arns     = [module.vscode_config.config_arn]
}

# Loop through list of users for creation
# Create SageMaker users for the domain, looping through a list of user names
module "sagemaker_user" {
  for_each  = { for user in var.user_names : user => user }
  source    = "../modules/sagemaker_user"
  domain_id = module.sagemaker_domain.domain_id
  user_name = each.value
}