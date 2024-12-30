output "image_name" {
  value = aws_sagemaker_image.image.image_name
}

output "image_version" {
  value = aws_sagemaker_image_version.image_version.version
}

output "app_image_config_name" {
  value = aws_sagemaker_app_image_config.image_config.app_image_config_name
}


