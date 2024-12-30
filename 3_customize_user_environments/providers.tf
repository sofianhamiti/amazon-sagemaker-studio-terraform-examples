provider "aws" {
  # region = "eu-west-1"
  default_tags {
    tags = {
      project     = "ABC"
      environment = "dev"
      cost-center = "xyz"
    }
  }
}