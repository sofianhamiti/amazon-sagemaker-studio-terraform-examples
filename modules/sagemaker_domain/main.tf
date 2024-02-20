resource "aws_sagemaker_domain" "sagemaker_domain" {
  domain_name = var.domain_name
  auth_mode = var.auth_mode
  vpc_id = var.vpc_id
  subnet_ids = var.subnet_ids
  app_network_access_type = var.app_network_access_type

  default_user_settings {
    execution_role = var.execution_role_arn
    security_groups = var.security_group_ids
    default_landing_uri = "studio::"
    studio_web_portal = "ENABLED"
    space_storage_settings {
      default_ebs_storage_settings {
        default_ebs_volume_size_in_gb = 100
        maximum_ebs_volume_size_in_gb = 1024
      }
    }

    # OPTIONALLY ATTACHED EFS FILE SYSTEM
    dynamic "custom_file_system_config" {
      for_each = var.efs_file_system_id != null && var.efs_folder_path != null ? [1] : []
      content {
        efs_file_system_config {
          file_system_id = var.efs_file_system_id
          file_system_path = var.efs_folder_path
        }
      }
    }

    # OPTIONAL LIFECYCLE CONFIG FOR CODE EDITOR
    dynamic "code_editor_app_settings" {
      for_each = var.lifecycle_config_arns != null ? [1] : [] 

      content {
        lifecycle_config_arns = var.lifecycle_config_arns 
      }
    }    
  }
}