# Lambda
variable "lambda_role_arn" {
  type    = string
  default = null
}

variable "lambda_function_name" {
  type    = string
  default = "sagemaker-efs-handler"
}

# EFS Filesystem
variable "efs_folder_path" {
  type    = string
  default = null
}

variable "lambda_mount_path" {
  type    = string
  default = null
}

# VPC
variable "private_subnet_ids" {
  type    = list(string)
  default = null
}

variable "security_group_ids" {
  type    = list(string)
  default = null
}