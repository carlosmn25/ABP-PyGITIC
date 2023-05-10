provider "aws" {
  region = "us-east-1"
}

module "dynamodb" {
  source = "./dynamodb"
}

module "lambdas" {
  source     = "./lambdas"
  account_id = var.account_id
}

module "ec2" {
  source = "./ec2"
}
