module "ng_demo_project" {
  source = "../../module"

  api_name                    = "LambdaAPIAngularDemo"
  api_description             = "Lambda API Gateway Angular Demo"
  lambda_function_name        = "aws-lambda-api-ng-demo"
  lambda_function_description = "Lambda API Gateway Angular Demo"
  lambda_role_name            = "aws-lambda-api-ng-demo-role"
  s3_bucket_prefix            = "aws-lambda-api-ng-demo"
  app_source_dir              = "ng-dist"
}

resource "aws_api_gateway_deployment" "ng_test" {
  depends_on = [
    "module.ng_demo_project"
  ]
  rest_api_id = "${module.ng_demo_project.rest_api_id}"
  stage_name  = "ngtest"
}

output "angular_lambda_test_url" {
  value = "https://${aws_api_gateway_deployment.ng_test.rest_api_id}.execute-api.${module.ng_demo_project.region}.amazonaws.com/${aws_api_gateway_deployment.ng_test.stage_name}"
}
