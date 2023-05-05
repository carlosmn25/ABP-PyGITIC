provider "aws" {
  region = "us-east-1"
}

module "dynamodb" {
  source = "./dynamodb"
}

module "lambdas" {
  source = "./lambdas"
}