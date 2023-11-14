provider "aws" {
  region                      = "sa-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
}

module "aws_lambda" {
  source          = "./modules/lambda"
  lambda_function = "test_lambda"
  bucket_name     = "test-bucket"
}
