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
  description = "List of user names to create in the domain"
  type        = list(string)
  default     = []
}

# Lifecycle Config Scripts
variable "lcc_name_vscode" {
  description = "Name of the lifecycle configuration for VS Code"
  type        = string
  default     = null
}

variable "lcc_script_vscode" {
  description = "Lifecycle configuration script for VS Code"
  type        = string
  default     = null
}

variable "lcc_name_jupyterlab" {
  description = "Name of the lifecycle configuration for JupyterLab"
  type        = string
  default     = null
}

variable "lcc_script_jupyterlab" {
  description = "Lifecycle configuration script for JupyterLab"
  type        = string
  default     = null
}

# Custom Container Images
variable "image_name_vscode" {
  description = "Name for the VS Code custom container image"
  type        = string
  default     = null
}

variable "image_folder_vscode" {
  description = "Folder containing VS Code custom container image files"
  type        = string
  default     = null
}

variable "image_name_jupyterlab" {
  description = "Name for the JupyterLab custom container image"
  type        = string
  default     = null
}

variable "image_folder_jupyterlab" {
  description = "Folder containing JupyterLab custom container image files"
  type        = string
  default     = null
}

# App Settings
variable "vscode_settings" {
  description = "Settings for VS Code editor"
  type = object({
    lifecycle_config_arns        = optional(list(string))
    idle_timeout_in_minutes      = optional(number)
    min_idle_timeout_in_minutes  = optional(number)
    max_idle_timeout_in_minutes  = optional(number)
    image_name                   = optional(string)
    image_version                   = optional(string)
  })
  default = null
}

variable "jupyter_settings" {
  description = "Settings for JupyterLab"
  type = object({
    lifecycle_config_arns        = optional(list(string))
    idle_timeout_in_minutes      = optional(number)
    min_idle_timeout_in_minutes  = optional(number)
    max_idle_timeout_in_minutes  = optional(number)
  })
  default = null
}

# Idle Timeout Settings (if not using vscode_settings or jupyter_settings)
variable "default_idle_timeout" {
  description = "Default idle timeout in minutes"
  type        = number
  default     = 60
}

variable "min_idle_timeout" {
  description = "Minimum idle timeout in minutes"
  type        = number
  default     = 60
}

variable "max_idle_timeout" {
  description = "Maximum idle timeout in minutes"
  type        = number
  default     = 240
}
