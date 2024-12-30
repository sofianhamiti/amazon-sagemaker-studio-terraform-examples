data "aws_iam_policy" "AmazonSageMakerFullAccess" {
  name = "AmazonSageMakerFullAccess"
}

data "aws_iam_policy" "AdministratorAccess" {
  name = "AdministratorAccess"
}

data "aws_iam_policy_document" "sagemaker_domain_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "sagemaker_domain_default_execution_role" {
  name               = var.execution_role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.sagemaker_domain_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "sagemaker_full_access" {
  role       = aws_iam_role.sagemaker_domain_default_execution_role.name
  policy_arn = data.aws_iam_policy.AmazonSageMakerFullAccess.arn
}

resource "aws_iam_role_policy_attachment" "administrator_access" {
  role       = aws_iam_role.sagemaker_domain_default_execution_role.name
  policy_arn = data.aws_iam_policy.AdministratorAccess.arn
}
