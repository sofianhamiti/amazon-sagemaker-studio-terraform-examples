data "aws_region" "current" {}

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

# Customize user environments using lifecycle configs
# module "jupyterlab_config" {
#   source            = "../modules/sagemaker_lifecycle_config"
#   lcc_name          = var.lcc_name_jupyterlab
#   lcc_config_script = var.lcc_script_jupyterlab
#   app_type          = "JupyterLab"
# }

# module "vscode_config" {
#   source            = "../modules/sagemaker_lifecycle_config"
#   lcc_name          = var.lcc_name_vscode
#   lcc_config_script = var.lcc_script_vscode
#   app_type          = "CodeEditor"
# }

# Customize user environments using custom container images
module "custom_container_image_vscode" {
  source         = "../modules/sagemaker_custom_image"
  image_name     = var.image_name_vscode
  image_folder   = var.image_folder_vscode
  aws_region     = data.aws_region.current.name
  execution_role = module.sagemaker_domain_execution_role.role_arn
}

# Studio Domain
module "sagemaker_domain" {
  source                  = "../modules/sagemaker_domain"
  domain_name            = var.domain_name
  auth_mode              = var.auth_mode
  app_network_access_type = var.app_network_access_type
  vpc_id                 = module.sagemaker_domain_vpc.vpc_id
  subnet_ids             = module.sagemaker_domain_vpc.private_subnet_ids
  execution_role_arn     = module.sagemaker_domain_execution_role.role_arn
  security_group_ids     = module.sagemaker_domain_vpc.security_group_ids

  # VS Code settings
  vscode_settings = {
    # lifecycle_config_arns     = [module.vscode_config.config_arn]
    idle_timeout_in_minutes     = var.default_idle_timeout
    min_idle_timeout_in_minutes = var.min_idle_timeout
    max_idle_timeout_in_minutes = var.max_idle_timeout
    image_name                  = module.custom_container_image_vscode.image_name
    image_version               = module.custom_container_image_vscode.image_version
    app_image_config_name       = module.custom_container_image_vscode.app_image_config_name
  }

  # JupyterLab settings
  jupyter_settings = {
    # lifecycle_config_arns     = [module.jupyterlab_config.config_arn]
    idle_timeout_in_minutes   = var.default_idle_timeout
    min_idle_timeout_in_minutes = var.min_idle_timeout
    max_idle_timeout_in_minutes = var.max_idle_timeout
  }
}

# Loop through list of users for creation
# Create SageMaker users for the domain, looping through a list of user names
module "sagemaker_user" {
  for_each  = { for user in var.user_names : user => user }
  source    = "../modules/sagemaker_user"
  domain_id = module.sagemaker_domain.domain_id
  user_name = each.value
}