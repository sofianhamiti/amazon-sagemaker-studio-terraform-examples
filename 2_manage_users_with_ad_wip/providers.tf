provider "aws" {
  default_tags {
    tags = {
      project     = "ABC"
      environment = "dev"
      cost-center = "xyz"
    }
  }
}