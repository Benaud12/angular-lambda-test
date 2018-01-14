# AWS Lambda API App

Creates an API Gateway url integrating with a Lamdba function running an application from source code stored in S3.

Demos:
1. [Simple Nodejs Express server app](#nodejs-express-demo)
1. [Angular Universal prerendered app](#angular-universal-demo)

## Create New API App

Create new project folder
```
mkdir projects/my-project
```

Create your application directory with your lambda function handler in file `lambda.js`
```
mkdir projects/my-project/my-app
touch projects/my-project/my-app/lambda.js
```
```js
// lambda.js
'use strict';

exports.handler = (event, context, callback) => {
  callback(null, {
    statusCode: 200,
    body: {
      "message": "Hello World!"
    },
    headers: {
      "content-type": "application/json"
    }
  });
};
```

Create your terraform module
```hcl
# This module will create the following:
#   - API Gateway named `MyProjectAPI`
#   - Lambda function named `my-lambda-api-app`
#   - S3 bucket with prefix `my-lambda-api-app`
#   - IAM role named `my-lambda-api-app-role`
module "my_project" {
  source = "../../module"

  # Variables and any deafults are defined in module/variables.tf
  api_name                    = "MyProjectAPI"
  api_description             = "My Lambda API Gateway"
  lambda_function_name        = "my-lambda-api-app"
  lambda_function_description = "My Lambda API Gateway"
  lambda_role_name            = "my-lambda-api-app-role"
  s3_bucket_prefix            = "my-lambda-api-app"
  app_source_dir              = "my-app" # Default is `dist`
}

# This will create a deployment endpoint for the API Gateway, path `/test`
#   - multiple deployments can be built from the same API
resource "aws_api_gateway_deployment" "test" {
  depends_on = [
    "module.my_project"
  ]
  rest_api_id = "${module.my_project.rest_api_id}"
  stage_name  = "test"
}

# This will output the public url of the API Gateway to the command line
output "my_project_test_url" {
  value = "https://${aws_api_gateway_deployment.test.rest_api_id}.execute-api.${module.my_project.region}.amazonaws.com/${aws_api_gateway_deployment.test.stage_name}"
}
```

Install Terraform https://www.terraform.io/downloads.html

Set up credentials
```
export AWS_ACCESS_KEY_ID="<< SOME_KEY >>"
export AWS_SECRET_ACCESS_KEY="<< SOME_SECRET >>"
export AWS_DEFAULT_REGION="<< AWS_REGION >>"
```

Run the following from the root of your project
```
terraform init
# terraform plan ## if you want to
terraform apply
```

## Demo Apps

### Nodejs Express Demo

Basic demo application `projects/demo`.

Live example url:
https://qwic54iu0e.execute-api.eu-west-1.amazonaws.com/test

### Angular Universal Demo

Example Angular application demo, using Angular universal for prerendering.

Application built from [Angular Universal Base](https://github.com/Benaud12/angular-universal-base/tree/lambda-test) project.

Live example url:
https://zdjxiqnzuj.execute-api.eu-west-1.amazonaws.com/ngtest
