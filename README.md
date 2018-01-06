# Angular Lambda Test

Currently creates an API Gateway integrating with a Lamdba function returning 'hello world' message

Working example:
https://zaihbpv8g7.execute-api.eu-west-1.amazonaws.com/test

## To Run

Install Terraform https://www.terraform.io/downloads.html

Set up credentials
```
export AWS_ACCESS_KEY_ID="<< SOME_KEY >>"
export AWS_SECRET_ACCESS_KEY="<< SOME_SECRET >>"
export AWS_DEFAULT_REGION="<< AWS_REGION >>"
```

From the root of the project, initailise, (plan ?) and apply
```
terraform init
# terraform plan ## if you want to
terraform apply
```

## TODO - OTHER STUFF
