provider "aws"{
    region=""
    secret_key=""
    access_key = ""
}

resource "aws_lambda_function" "test_lambda" {
    filename         = "lambda_function.zip"
    function_name    = "test"
    role             = "<ARN>"
    handler          = "lambda_function.lambda_handler"
    runtime          = "python3.9"
    source_code_hash = filebase64sha256("lambda_function.zip")
}
resource "aws_api_gateway_rest_api" "testAPI" {
    name        = "myAPI"
   endpoint_configuration {
      types     = ["REGIONAL"]       
   }
}
resource "aws_api_gateway_resource" "testresource" {
    parent_id   = aws_api_gateway_rest_api.testAPI.root_resource_id
    path_part   = "testapi"
    rest_api_id = aws_api_gateway_rest_api.testAPI.id           
}
resource "aws_api_gateway_method" "testMethod" {
    rest_api_id   = aws_api_gateway_rest_api.testAPI.id
    resource_id   = aws_api_gateway_resource.testresource.id
    http_method   = "GET"
    authorization = "NONE"           
}
resource "aws_api_gateway_method_response" "response_200" {
    rest_api_id = aws_api_gateway_rest_api.testAPI.id
    resource_id = aws_api_gateway_resource.testresource.id
    http_method = aws_api_gateway_method.testMethod.http_method
    status_code = "200"
    response_models = {
         "application/json" = "Empty"        
     }           
}
resource "aws_api_gateway_integration" "MyDemoIntegration" {
    rest_api_id          = aws_api_gateway_rest_api.testAPI.id
    resource_id          = aws_api_gateway_resource.testresource.id
    http_method          = aws_api_gateway_method.testMethod.http_method
    integration_http_method     = "POST"
     uri = aws_lambda_function.test_lambda.invoke_arn
    type                 = "AWS"
    passthrough_behavior    = "WHEN_NO_TEMPLATES"           
}  

resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
    rest_api_id        = aws_api_gateway_rest_api.testAPI.id
    resource_id        = aws_api_gateway_resource.testresource.id
    http_method        = aws_api_gateway_method.testMethod.http_method
    status_code        = aws_api_gateway_method_response.response_200.status_code
    response_templates = { "application/json" = "" }
    depends_on         = [aws_api_gateway_integration.MyDemoIntegration]
}