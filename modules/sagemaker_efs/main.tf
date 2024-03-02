# EFS file system
# Create an Elastic File System (EFS) for the SageMaker domain
resource "aws_efs_file_system" "efs" {
  encrypted = true
}

# EFS mount targets
# Create EFS mount targets in the private subnets
resource "aws_efs_mount_target" "sagemaker_efs_mount_targets" {
  count           = length(var.private_subnet_ids)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.private_subnet_ids[count.index]
  security_groups = var.security_group_ids
}

# EFS access point used by Lambda
# Create an EFS access point for the Lambda function
resource "aws_efs_access_point" "access_point_for_lambda" {
  file_system_id = aws_efs_file_system.efs.id
  posix_user {
    gid = 0
    uid = 0
  }
}

# Lambda Function handling the EFS folder creation
# Create a Lambda function, configured to access the EFS file system, with the necessary environment variables and VPC settings
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_efs_code/handler.py"
  output_path = "${path.module}/lambda_efs_code/lambda.zip"
}

resource "aws_lambda_function" "create_folder_in_efs" {
  filename      = "${path.module}/lambda_efs_code/lambda.zip"
  function_name = var.lambda_function_name
  role          = var.lambda_role_arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.12"
  file_system_config {
    arn              = aws_efs_access_point.access_point_for_lambda.arn
    local_mount_path = var.lambda_mount_path
  }
  environment {
    variables = {
      lambda_mount_path = var.lambda_mount_path
      efs_folder_path   = var.efs_folder_path
    }
  }
  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = var.security_group_ids
  }
  depends_on = [
    aws_efs_mount_target.sagemaker_efs_mount_targets,
    aws_efs_access_point.access_point_for_lambda
  ]
}

# Invoke the Lambda Function
# Invoke the Lambda function to create a folder in the EFS file system
resource "aws_lambda_invocation" "lambda_invocation" {
  function_name = aws_lambda_function.create_folder_in_efs.function_name
  input         = "{}"
}