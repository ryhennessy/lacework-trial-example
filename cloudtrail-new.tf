terraform {
  required_providers {
    lacework = {
      source = "lacework/lacework"
      version = "~> 0.3"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

provider "lacework" {
  account    = var.lacework-account 
  api_key    = var.lacework-api-key
  api_secret = var.lacework-api-secret 
}

module "aws_config" {
  source  = "lacework/config/aws"
  version = "~> 0.1"
  iam_role_name = "lacework-role"
}

module "aws_cloudtrail" {
  source  = "lacework/cloudtrail/aws"
  version = "~> 0.1"

  bucket_force_destroy  = true
  use_existing_iam_role = true
  iam_role_name         = module.aws_config.iam_role_name
  iam_role_arn          = module.aws_config.iam_role_arn
  iam_role_external_id  = module.aws_config.external_id
}
