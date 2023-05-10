#!/bin/bash

# But export as a variable in the environment
export TF_VAR_account_id=$(aws sts get-caller-identity | grep Account | cut -d '"' -f 4)
terraform init
terraform plan
terraform apply -auto-approve
