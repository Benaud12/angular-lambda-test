resource "aws_lambda_function" "angular_lamdba_test" {
  filename = "${data.archive_file.lambda.output_path}"
  function_name = "angular_lamdba_test"
  role = "${aws_iam_role.angular_lambda_test_role.arn}"
  handler = "index.handler"
  runtime = "nodejs6.10"
  source_code_hash = "${base64sha256(file("${data.archive_file.lambda.output_path}"))}"
}

resource "aws_iam_role" "angular_lambda_test_role" {
  name = "angular_lambda_test_role"
  assume_role_policy = "${file("lambda-role.json")}"
}

resource "aws_lambda_permission" "anular_lambda_test_api" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.angular_lamdba_test.arn}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.angular_lambda_test_api.id}/*"
}
