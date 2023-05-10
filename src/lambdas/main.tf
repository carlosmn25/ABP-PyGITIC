provider "aws" {
  region = "us-east-1"
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/python/"
  output_path = "${path.module}/python/code.zip"
}

resource "aws_lambda_function" "terraform_lambda_func" {
  filename      = "${path.module}/python/code.zip"
  function_name = "Sensor-Lambda-Function"
  # Combine in role the string "arn:aws:iam::" with the variable account_id and the string ":role/LabRole
  role    = "arn:aws:iam::${var.account_id}:role/LabRole"
  handler = "sensor.lambda_handler"
  runtime = "python3.8"
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
