# IAM role
module "sagemaker_domain_execution_role" {
  source  = "../modules/iam"
  execution_role_name = var.execution_role_name
}

# VPC
module "sagemaker_domain_vpc" {
  source = "../modules/vpc"
  cidr_block = var.cidr_block
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones = var.availability_zones
}

# Lifecycle config
data "local_file" "lifecycle_script" {
  filename = "${path.module}/lifecycle_config_scripts/code_editor.sh"
}

resource "aws_sagemaker_studio_lifecycle_config" "code_editor" {
  studio_lifecycle_config_name = "example2"
  studio_lifecycle_config_app_type = "CodeEditor" # 'CodeEditor'|'JupyterLab'
  studio_lifecycle_config_content = base64encode(data.local_file.lifecycle_script.content)
}

# Studio Domain
module "sagemaker_domain" {
  source= "../modules/sagemaker_domain"
  domain_name = var.domain_name
  auth_mode = var.auth_mode
  app_network_access_type = var.app_network_access_type
  vpc_id = module.sagemaker_domain_vpc.vpc_id
  subnet_ids = module.sagemaker_domain_vpc.private_subnet_ids
  execution_role_arn = module.sagemaker_domain_execution_role.role_arn
  security_group_ids = module.sagemaker_domain_vpc.security_group_ids
  lifecycle_config_arns = [aws_sagemaker_studio_lifecycle_config.code_editor.arn]
}

# Loop through list of users for creation
module "sagemaker_user" {
  for_each = { for user in var.user_names : user => user }

  source= "../modules/sagemaker_user"
  domain_id = module.sagemaker_domain.domain_id
  user_name = each.value
}
