data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.cwd}/${var.app_source_dir}"
  output_path = "${path.cwd}/lambda.zip"
}

data "aws_caller_identity" "current" {}
