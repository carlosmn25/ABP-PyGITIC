provider "aws" {
  region                   = "us-east-1"
  //shared_credentials_files = ["/home/ajtarraga/.aws/credentials"]
}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/python/"
  output_path = "${path.module}/python/hello-python.zip"
}

resource "aws_lambda_function" "terraform_lambda_func" {
  filename      = "${path.module}/python/hello-python.zip"
  function_name = "Data-Lambda-Function"
  role          = "arn:aws:iam::466739547794:role/LabRole"
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

resource "aws_dynamodb_table" "electrolinera_table" {
  name           = "Electrolinera"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "ID_Electrolinera"

  attribute {
    name = "ID_Electrolinera"
    type = "N"
  }
}

resource "aws_dynamodb_table" "punto_carga_table" {
  name           = "PuntoCarga"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "ID_PuntoCarga"

  attribute {
    name = "ID_PuntoCarga"
    type = "N"
  }
}

resource "aws_dynamodb_table" "estado_table" {
  name           = "Estado"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "ID_Estado"

  attribute {
    name = "ID_Estado"
    type = "N"
  }
}

resource "aws_dynamodb_table" "estadisticas_table" {
  name           = "Estadisticas"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "ID_Estadisticas"

  attribute {
    name = "ID_Estadisticas"
    type = "N"
  }
}
