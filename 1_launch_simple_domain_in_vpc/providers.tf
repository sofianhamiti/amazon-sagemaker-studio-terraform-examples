provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      project     = "ABC"
      environment = "dev"
      cost-center = "xyz"
    }
  }
}