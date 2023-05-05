provider "aws" {
  region = "us-east-1"
  //shared_credentials_files = ["/home/ajtarraga/.aws/credentials"]
}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/python/"
  output_path = "${path.module}/python/hello-python.zip"
}

// Lambda para inserción de datos del sensor de un punto de carga
resource "aws_lambda_function" "terraform_lambda_func" {
  filename      = "${path.module}/python/hello-python.zip"
  function_name = "Data-Lambda-Function"
  role          = "arn:aws:iam::595531780921:role/LabRole" //TODO: Tomarlo de una variable o similar para que sea configurable
  handler       = "hello-python.lambda_handler"
  runtime       = "python3.8"
}

resource "aws_lambda_function_url" "url1" {
  function_name      = aws_lambda_function.terraform_lambda_func.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

// Lambda para ofrecer datos de los puntos de carga a los coches (Car API)
resource "aws_lambda_function" "lambda_car_api" {
  filename      = "${path.module}/python/hello-python.zip"
  function_name = "Car-API-Lambda-Function"
  role          = "arn:aws:iam::595531780921:role/LabRole" //TODO: Tomarlo de una variable o similar para que sea configurable
  handler       = "car_api_code.lambda_handler"
  runtime       = "python3.8"
}

resource "aws_lambda_function_url" "url_car_api" {
  function_name      = aws_lambda_function.lambda_car_api.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

/*resource "aws_api_gateway_rest_api" "api_gateway" {
  name = "Data-API-Gateway"
}

resource "aws_api_gateway_method" "post_form" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_gateway_integration_root_post" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_method.post_form.resource_id
  http_method = aws_api_gateway_method.post_form.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.terraform_lambda_func.invoke_arn
}

resource "aws_api_gateway_method" "options_form" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_gateway_integration_root_option" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_method.options_form.resource_id
  http_method = aws_api_gateway_method.options_form.http_method

  integration_http_method = "OPTIONS"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.terraform_lambda_func.invoke_arn
}

resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  depends_on  = [aws_api_gateway_integration.api_gateway_integration_root_post]
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = "stage-api"
}

output "lambda_function_invoke_arn" {
  value = aws_lambda_function.terraform_lambda_func.invoke_arn
}

output "lambda_function_arn" {
  value = aws_lambda_function.terraform_lambda_func.lambda_arn
}*/
