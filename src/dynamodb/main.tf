provider "aws" {
    region = "us-east-1"
}

resource "aws_dynamodb_table" "electrolinera_table" {
  name             = "Electrolinera"
  billing_mode     = "PROVISIONED"
  read_capacity    = 1
  write_capacity   = 1
  hash_key         = "ID_Electrolinera"
  
  attribute {
    name = "ID_Electrolinera"
    type = "N"
  }
}

resource "aws_dynamodb_table" "punto_carga_table" {
  name             = "PuntoCarga"
  billing_mode     = "PROVISIONED"
  read_capacity    = 1
  write_capacity   = 1
  hash_key         = "ID_PuntoCarga"
  
  attribute {
    name = "ID_PuntoCarga"
    type = "N"
  }
}

resource "aws_dynamodb_table" "estado_table" {
  name             = "Estado"
  billing_mode     = "PROVISIONED"
  read_capacity    = 1
  write_capacity   = 1
  hash_key         = "ID_Estado"
  
  attribute {
    name = "ID_Estado"
    type = "N"
  }
}

resource "aws_dynamodb_table" "estadisticas_table" {
  name             = "Estadisticas"
  billing_mode     = "PROVISIONED"
  read_capacity    = 1
  write_capacity   = 1
  hash_key         = "ID_Estadisticas"
  
  attribute {
    name = "ID_Estadisticas"
    type = "N"
  }
}