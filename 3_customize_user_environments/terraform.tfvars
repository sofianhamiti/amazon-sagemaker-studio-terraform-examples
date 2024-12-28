#######################
# Regional Settings
#######################
aws_region = "eu-west-1"

#######################
# IAM Configuration
#######################
execution_role_name = "sagemaker_domain_exec_role_default"

#######################
# VPC Configuration
#######################
cidr_block           = "10.0.0.0/23"
public_subnet_cidrs  = ["10.0.0.0/25", "10.0.0.128/25"]
private_subnet_cidrs = ["10.0.1.0/25", "10.0.1.128/25"]
availability_zones   = ["eu-west-1a", "eu-west-1b"]

#######################
# SageMaker Domain
#######################
domain_name             = "sagemaker-domain"
auth_mode               = "IAM"
app_network_access_type = "VpcOnly"

#######################
# Lifecycle Configs
#######################
# VS Code
lcc_name_vscode   = "vscode-config"
lcc_script_vscode = "vscode_config.sh"

# JupyterLab
lcc_name_jupyterlab   = "jupyterlab-config"
lcc_script_jupyterlab = "jupyterlab_config.sh"

#######################
# Custom Container Images
#######################
# VS Code
image_name_vscode   = "vscode-image"
image_folder_vscode = "vscode"

# JupyterLab
image_name_jupyterlab   = "jupyterlab-image"
image_folder_jupyterlab = "jupyterlab"

#######################
# Idle Timeout Settings
#######################
default_idle_timeout       = 60
min_idle_timeout   = 60
max_idle_timeout   = 240

#######################
# SageMaker Users
#######################
user_names = ["user1", "user2"]