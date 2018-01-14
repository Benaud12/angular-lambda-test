variable "region" {
  default = "eu-west-1"
}

variable "api_name" {}

variable "api_description" {}

variable "app_source_dir" {
  default = "dist"
}

variable "lambda_function_name" {}

variable "lambda_function_description" {}

variable "lambda_function_handler" {
  default = "lambda.handler"
}

variable "lambda_function_runtime" {
  default = "nodejs6.10"
}

variable "lambda_role_name" {}

variable "s3_bucket_prefix" {}
