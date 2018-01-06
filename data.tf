data "archive_file" "lambda" {
  type = "zip"
  source_file = "index.js"
  output_path = "lambda.zip"
}

data "aws_caller_identity" "current" {}
