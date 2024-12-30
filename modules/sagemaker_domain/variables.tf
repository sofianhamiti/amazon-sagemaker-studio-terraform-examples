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

variable "vscode_settings" {
  description = "Settings for VS Code editor"
  type = object({
    lifecycle_config_arns       = optional(list(string))
    idle_timeout_in_minutes     = optional(number)
    min_idle_timeout_in_minutes = optional(number)
    max_idle_timeout_in_minutes = optional(number)
    image_name                  = optional(string)
    image_version               = optional(string)
    app_image_config_name       = optional(string)
  })
  default = null
}

variable "jupyter_settings" {
  description = "Settings for JupyterLab"
  type = object({
    lifecycle_config_arns     = optional(list(string))
    idle_timeout_in_minutes   = optional(number)
    min_idle_timeout_in_minutes = optional(number)
    max_idle_timeout_in_minutes = optional(number)
  })
  default = null
}
