#!/bin/bash

#Include the credentials in the user_data.sh
cp ~/.aws/credentials .
sudo sed '8r credentials' ec2/user_data_template.sh > ec2/user_data.sh
rm credentials


# But export as a variable in the environment
export TF_VAR_account_id=$(aws sts get-caller-identity | grep Account | cut -d '"' -f 4)
terraform init
terraform plan -out tf_plan.out > /dev/null
terraform apply -auto-approve

# Take the url of the lambda called 'Car-API-Lambda-Function'
url=$(aws lambda get-function-url-config --function-name Car-API-Lambda-Function | grep FunctionUrl | cut -d '"' -f 4)
echo -e "\nThe url of the lambda car_api is: $url"

# Take the url of the lambda called 'Sensor-Lambda-Function'
url=$(aws lambda get-function-url-config --function-name Sensor-Lambda-Function | grep FunctionUrl | cut -d '"' -f 4)
echo -e "\nThe url of the lambda sensor is: $url"

# Take the url of the ec2 instance called 'statistics-webserver'
url=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=statistics-webserver" | grep PublicIpAddress | cut -d '"' -f 4)
echo -e "\nThe url of the statistics webserver is: http://$url:3000"
