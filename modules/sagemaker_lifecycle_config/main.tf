# Lifecycle configs
# Read the content of a local file for the lifecycle configuration
data "local_file" "lifecycle_script" {
  filename = "${path.module}/lifecycle_config_scripts/${var.lcc_config_script}"
}

# Create a SageMaker Studio Lifecycle Configuration for the CodeEditor app type
resource "aws_sagemaker_studio_lifecycle_config" "code_editor" {
  studio_lifecycle_config_name     = var.lcc_name
  studio_lifecycle_config_app_type = var.app_type # 'CodeEditor' or 'JupyterLab'
  studio_lifecycle_config_content  = base64encode(data.local_file.lifecycle_script.content)
}
