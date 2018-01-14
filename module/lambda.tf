resource "aws_lambda_function" "function" {
  s3_bucket     = "${aws_s3_bucket_object.lambda.bucket}"
  s3_key        = "${aws_s3_bucket_object.lambda.key}"
  function_name = "${var.lambda_function_name}"
  description   = "${var.lambda_function_description}"
  role          = "${aws_iam_role.lambda.arn}"
  handler       = "${var.lambda_function_handler}"
  runtime       = "${var.lambda_function_runtime}"
  # Have to add `source_code_hash` instead of `s3_object_version` due to issue recognising changes to the s3 object
  # https://github.com/hashicorp/terraform/issues/8829#issuecomment-246846780
  source_code_hash = "${base64sha256(file("${data.archive_file.lambda.output_path}"))}"
}

resource "aws_iam_role" "lambda" {
  name = "${var.lambda_role_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "apigateway.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_permission" "permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.function.arn}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*"
}
