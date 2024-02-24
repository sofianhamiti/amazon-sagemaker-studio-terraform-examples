# Create ECR repository
resource "aws_ecr_repository" "ecr_repository" {
  name = var.image_name
}

# # Build and push Docker image to ECR
# resource "null_resource" "docker_build_and_push" {
#   provisioner "local-exec" {
#     command     = "sh build_and_push.sh ${aws_ecr_repository.my_repo.name}"
#     working_dir = "../customer_container_image"

#     environment = {
#       ECR_REPOSITORY_URL = "${aws_ecr_repository.sagemaker_repository.repository_url}"
#       IMAGE_TAG          = "${sha256(file("${path.module}/build_and_push_image.sh"))}"
#     }
#   }

#   triggers = {
#     "run_at" = timestamp()
#   }

#   depends_on = [aws_ecr_repository.sagemaker_ecr_repository]
# }

resource "aws_sagemaker_image" "image" {
  image_name = var.image_name
  role_arn   = var.execution_role
  # depends_on = [ aws_sagemaker_image_version.image_version ]
}

resource "aws_sagemaker_image_version" "image_version" {
  image_name = var.image_name
  base_image = "366243680492.dkr.ecr.eu-west-1.amazonaws.com/example2:latest"
  depends_on = [ aws_sagemaker_image.image ]
}

resource "aws_sagemaker_app_image_config" "image_config" {
  app_image_config_name = var.image_name
  jupyter_lab_image_config {
    container_config {
      
    }
  }
  depends_on = [ aws_sagemaker_image_version.image_version ]
}
