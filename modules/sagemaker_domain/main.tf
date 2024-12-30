# Create the SageMaker domain with the specified configuration
resource "aws_sagemaker_domain" "sagemaker_domain" {
  domain_name             = var.domain_name
  auth_mode               = var.auth_mode
  vpc_id                 = var.vpc_id
  subnet_ids             = var.subnet_ids
  app_network_access_type = var.app_network_access_type

  domain_settings {
    docker_settings {
      enable_docker_access = "ENABLED"
    }
  }

  default_user_settings {
    execution_role      = var.execution_role_arn
    security_groups     = var.security_group_ids
    default_landing_uri = "studio::"
    studio_web_portal   = "ENABLED"

    space_storage_settings {
      default_ebs_storage_settings {
        default_ebs_volume_size_in_gb = 100
        maximum_ebs_volume_size_in_gb = 1024
      }
    }

    dynamic "custom_file_system_config" {
      for_each = var.efs_file_system_id != null && var.efs_folder_path != null ? [1] : []
      content {
        efs_file_system_config {
          file_system_id   = var.efs_file_system_id
          file_system_path = var.efs_folder_path
        }
      }
    }

    dynamic "code_editor_app_settings" {
      for_each = var.vscode_settings != null ? [1] : []
      content {
        lifecycle_config_arns = try(var.vscode_settings.lifecycle_config_arns, null)

        dynamic "app_lifecycle_management" {
          for_each = try(var.vscode_settings.idle_timeout_in_minutes, null) != null ? [1] : []
          content {
            idle_settings {
              idle_timeout_in_minutes      = var.vscode_settings.idle_timeout_in_minutes
              lifecycle_management         = "ENABLED"
              min_idle_timeout_in_minutes  = var.vscode_settings.min_idle_timeout_in_minutes
              max_idle_timeout_in_minutes  = var.vscode_settings.max_idle_timeout_in_minutes
            }
          }
        }

        dynamic "custom_image" {
          for_each = try(var.vscode_settings.image_name, null) != null ? [1] : []
          content {
            image_name           = var.vscode_settings.image_name
            image_version_number = var.vscode_settings.image_version
            app_image_config_name = var.vscode_settings.app_image_config_name
          }
        }
      }
    }

    dynamic "jupyter_lab_app_settings" {
      for_each = var.jupyter_settings != null ? [1] : []
      content {
        lifecycle_config_arns = try(var.jupyter_settings.lifecycle_config_arns, null)

        dynamic "app_lifecycle_management" {
          for_each = try(var.jupyter_settings.idle_timeout_in_minutes, null) != null ? [1] : []
          content {
            idle_settings {
              idle_timeout_in_minutes      = var.jupyter_settings.idle_timeout_in_minutes
              lifecycle_management         = "ENABLED"
              min_idle_timeout_in_minutes  = var.jupyter_settings.min_idle_timeout_in_minutes
              max_idle_timeout_in_minutes  = var.jupyter_settings.max_idle_timeout_in_minutes
            }
          }
        }
      }
    }
  }
}
