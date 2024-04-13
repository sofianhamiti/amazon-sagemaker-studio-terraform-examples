variable "aws_region" {
  description = "The AWS region where resources will be provisioned."
  type        = string
}

# IAM
variable "execution_role_name" {
  description = "Name for the default role used in the SageMaker domain"
  type        = string
}

# VPC
variable "cidr_block" {
  type        = string
  description = "CIDR block for SageMaker VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones"
}

# Domain
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

# User
variable "user_names" {
  type = list(string)
}

# Optional Lifecyle Config Script For Code Editor
variable "lcc_name_vscode" {
  type = string
}

variable "lcc_script_vscode" {
  type = string
}

variable "lcc_name_jupyterlab" {
  type = string
}

variable "lcc_script_jupyterlab" {
  type = string
}

# Custom Container Image
variable "image_name_jupyterlab" {
  type = string
}

variable "image_folder_jupyterlab" {
  type = string
}

variable "image_name_vscode" {
  type = string
}

variable "image_folder_vscode" {
  type = string
}