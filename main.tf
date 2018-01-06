resource "aws_api_gateway_rest_api" "angular_lambda_test_api" {
  name = "AngularLambdaTestAPI"
  description = "Angular Lambda Test API"
  depends_on = [
    "aws_lambda_function.angular_lamdba_test"
  ]
}

resource "aws_api_gateway_resource" "angular_lambda_test_api_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.angular_lambda_test_api.id}"
  parent_id = "${aws_api_gateway_rest_api.angular_lambda_test_api.root_resource_id}"
  path_part = "{urlPath+}"
}

resource "aws_api_gateway_method" "angular_lambda_test_root_method" {
  rest_api_id = "${aws_api_gateway_rest_api.angular_lambda_test_api.id}"
  resource_id = "${aws_api_gateway_rest_api.angular_lambda_test_api.root_resource_id}"
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "angular_lambda_test_wildcard_method" {
  rest_api_id = "${aws_api_gateway_rest_api.angular_lambda_test_api.id}"
  resource_id = "${aws_api_gateway_resource.angular_lambda_test_api_resource.id}"
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "angular_lambda_test_api_root_method_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.angular_lambda_test_api.id}"
  resource_id = "${aws_api_gateway_rest_api.angular_lambda_test_api.root_resource_id}"
  http_method = "${aws_api_gateway_method.angular_lambda_test_root_method.http_method}"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.angular_lamdba_test.arn}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_integration" "angular_lambda_test_api_wildcard_method_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.angular_lambda_test_api.id}"
  resource_id = "${aws_api_gateway_resource.angular_lambda_test_api_resource.id}"
  http_method = "${aws_api_gateway_method.angular_lambda_test_wildcard_method.http_method}"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.angular_lamdba_test.arn}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_deployment" "angular_lambda_test_deployment" {
  depends_on = [
    "aws_api_gateway_integration.angular_lambda_test_api_root_method_integration",
    "aws_api_gateway_integration.angular_lambda_test_api_wildcard_method_integration"
  ]
  rest_api_id = "${aws_api_gateway_rest_api.angular_lambda_test_api.id}"
  stage_name  = "test"
}

output "angular_lambda_test_url" {
  value = "https://${aws_api_gateway_deployment.angular_lambda_test_deployment.rest_api_id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_deployment.angular_lambda_test_deployment.stage_name}"
}
