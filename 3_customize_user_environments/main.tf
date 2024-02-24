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
  lifecycle_config_arns   = [aws_sagemaker_studio_lifecycle_config.code_editor.arn]
}

# Loop through list of users for creation
# Create SageMaker users for the domain, looping through a list of user names
module "sagemaker_user" {
  for_each  = { for user in var.user_names : user => user }
  source    = "../modules/sagemaker_user"
  domain_id = module.sagemaker_domain.domain_id
  user_name = each.value
}

# Lifecycle configs
# Read the content of a local file for the lifecycle configuration
data "local_file" "lifecycle_script" {
  filename = "../lifecycle_config_scripts/${var.vscode_config_script}"
}

# Create a SageMaker Studio Lifecycle Configuration for the CodeEditor app type
resource "aws_sagemaker_studio_lifecycle_config" "code_editor" {
  studio_lifecycle_config_name     = "vscode-config"
  studio_lifecycle_config_app_type = "CodeEditor" # 'CodeEditor' or 'JupyterLab'
  studio_lifecycle_config_content  = base64encode(data.local_file.lifecycle_script.content)
}

# Custom images
# Create ECR repository
resource "aws_ecr_repository" "sagemaker_ecr_repository" {
  name = var.ecr_repository_name
}

# Build and push Docker image to ECR
resource "null_resource" "docker_build_and_push" {
  provisioner "local-exec" {
    command     = "sh build_and_push.sh ${aws_ecr_repository.my_repo.name}"
    working_dir = "../customer_container_image"

    environment = {
      ECR_REPOSITORY_URL = "${aws_ecr_repository.sagemaker_repository.repository_url}"
      IMAGE_TAG          = "${sha256(file("${path.module}/build_and_push_image.sh"))}"
    }
  }

  triggers = {
    "run_at" = timestamp()
  }

  depends_on = [aws_ecr_repository.sagemaker_ecr_repository]
}