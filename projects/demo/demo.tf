module "demo_project" {
  source = "../../module"

  api_name                    = "LambdaAPIDemo"
  api_description             = "Lambda API Gateway Demo"
  lambda_function_name        = "aws-lambda-api-demo"
  lambda_function_description = "Lambda API Gateway Demo"
  lambda_role_name            = "aws-lambda-api-demo-role"
  s3_bucket_prefix            = "aws-lambda-api-demo"
}

resource "aws_api_gateway_deployment" "test" {
  depends_on = [
    "module.demo_project"
  ]
  rest_api_id = "${module.demo_project.rest_api_id}"
  stage_name  = "test"
}

output "lambda_api_app_test_url" {
  value = "https://${aws_api_gateway_deployment.test.rest_api_id}.execute-api.${module.demo_project.region}.amazonaws.com/${aws_api_gateway_deployment.test.stage_name}"
}
