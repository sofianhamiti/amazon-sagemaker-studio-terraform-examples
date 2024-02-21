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
  filename = "../lifecycle_config_scripts/${var.vscode_config_script}"
}

resource "aws_sagemaker_studio_lifecycle_config" "code_editor" {
  studio_lifecycle_config_name = "vscode-config"
  studio_lifecycle_config_app_type = "CodeEditor" # 'CodeEditor' or 'JupyterLab'
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
  efs_file_system_id=aws_efs_file_system.sagemaker_efs.id
  efs_folder_path=var.efs_folder_path
}

# Loop through list of users for creation
module "sagemaker_user" {
  for_each = { for user in var.user_names : user => user }
  
  source= "../modules/sagemaker_user"
  domain_id = module.sagemaker_domain.domain_id
  user_name = each.value
}

# EFS file system
resource "aws_efs_file_system" "sagemaker_efs" {
  encrypted = true
}

# EFS mount targets
resource "aws_efs_mount_target" "sagemaker_efs_mount_targets" {
  count           = length(module.sagemaker_domain_vpc.private_subnet_ids)
  file_system_id  = aws_efs_file_system.sagemaker_efs.id
  subnet_id       = module.sagemaker_domain_vpc.private_subnet_ids[count.index]
  security_groups = module.sagemaker_domain_vpc.security_group_ids
}

# EFS access point used by lambda
resource "aws_efs_access_point" "access_point_for_lambda" {
  file_system_id = aws_efs_file_system.sagemaker_efs.id 
  posix_user {
    gid = 0
    uid = 0
  }
}

# Lambda Function handling the EFS folder creation
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../lambda_efs_code/handler.py"
  output_path = "../lambda_efs_code/lambda.zip"
}

resource "aws_lambda_function" "create_folder_in_efs" {
  filename      = "../lambda_efs_code/lambda.zip"
  function_name = "sagemaker-efs-handler"
  role          = module.sagemaker_domain_execution_role.role_arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.12"
  file_system_config {
      arn = aws_efs_access_point.access_point_for_lambda.arn
      local_mount_path = var.lambda_mount_path
    }
  environment {
    variables = {
      lambda_mount_path = var.lambda_mount_path
      efs_folder_path = var.efs_folder_path
    }
  }
  vpc_config {
    subnet_ids         = module.sagemaker_domain_vpc.private_subnet_ids
    security_group_ids = module.sagemaker_domain_vpc.security_group_ids
  }
  depends_on = [aws_efs_mount_target.sagemaker_efs_mount_targets, aws_efs_access_point.access_point_for_lambda]
}

# Invoke the Lambda Function
resource "aws_lambda_invocation" "lambda_invocation" {
  function_name = aws_lambda_function.create_folder_in_efs.function_name
  input = "{}"
}
