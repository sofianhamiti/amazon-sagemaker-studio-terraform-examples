# Get Account ID
data "aws_caller_identity" "current" {}


# ECR repository
resource "aws_ecr_repository" "repository" {
  name = var.image_name
}

# Generate Unique ECR Image Tag
locals {
  # ecr_image_tag = formatdate("YYYYMMDDhhmmss", timestamp())
  ecr_image_tag = substr(uuid(), 0, 8)
  ecr_image_uri = "${aws_ecr_repository.repository.repository_url}:${local.ecr_image_tag}"
}

# Build and push Docker image to ECR
resource "null_resource" "docker_build_and_push" {
  provisioner "local-exec" {
    working_dir = "${path.module}/custom_container_images/${var.image_folder}"
    command     = "sh build_and_push.sh ${aws_ecr_repository.repository.name}"
    environment = {
      AWS_ACCOUNT_ID     = data.aws_caller_identity.current.account_id
      AWS_REGION         = var.aws_region
      IMAGE_NAME         = var.image_name
      ECR_REPOSITORY_URL = "${aws_ecr_repository.repository.repository_url}"
      ECR_IMAGE          = "${local.ecr_image_uri}"
    }
  }

  triggers = {
    always_run = "${local.ecr_image_uri}"
  }

  depends_on = [aws_ecr_repository.repository]
}


# Create SageMaker Image
resource "aws_sagemaker_image" "image" {
  image_name = var.image_name
  role_arn   = var.execution_role
  depends_on = [null_resource.docker_build_and_push]
}

resource "aws_sagemaker_image_version" "image_version" {
  image_name = var.image_name
  base_image = local.ecr_image_uri
  depends_on = [aws_sagemaker_image.image]
}

resource "aws_sagemaker_app_image_config" "image_config" {
  app_image_config_name = var.image_name
  jupyter_lab_image_config {
    container_config {

    }
  }
  depends_on = [aws_sagemaker_image_version.image_version]
}
