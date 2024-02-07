resource "aws_sagemaker_user_profile" "user" {
  domain_id = var.domain_id
  user_profile_name = var.user_name
}