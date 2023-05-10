provider "aws" {
  region = "us-east-1"
}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/python/"
  output_path = "${path.module}/python/code.zip"
}

resource "aws_lambda_function" "terraform_lambda_func" {
  filename      = "${path.module}/python/code.zip"
  function_name = "Sensor-Lambda-Function"
  role          = "arn:aws:iam::466739547794:role/LabRole"
  handler       = "sensor.lambda_handler"
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
