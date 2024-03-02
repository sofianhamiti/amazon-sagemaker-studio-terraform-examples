variable "domain_name" {
  description = "Sagemaker Domain Name"
  type        = string
}

variable "auth_mode" {
  description = "The mode of authentication that members use to access the domain. Valid values are IAM and SSO"
  type        = string
}

variable "app_network_access_type" {
  description = "Specifies the VPC used for non-EFS traffic. Valid values are PublicInternetOnly and VpcOnly"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "execution_role_arn" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "efs_file_system_id" {
  type    = string
  default = null
}

variable "efs_folder_path" {
  type    = string
  default = null
}

variable "jupyterlab_lifecycle_config_arns" {
  type    = list(string)
  default = null
}

variable "vscode_lifecycle_config_arns" {
  type    = list(string)
  default = null
}