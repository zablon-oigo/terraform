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