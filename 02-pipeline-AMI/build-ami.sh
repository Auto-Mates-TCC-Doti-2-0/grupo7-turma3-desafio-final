#!/bin/bash

VERSAO=$(git describe --tags $(git rev-list --tags --max-count=1))

cd 02-pipeline-AMI/terraform
RESOURCE_ID=$(terraform output | grep resource_id | awk '{print $2;exit}' | sed -e "s/\",//g")

cd ../terraform-ami
terraform init -no-color
TF_VAR_versao=$VERSAO TF_VAR_resource_id=$RESOURCE_ID terraform apply -auto-approve -no-color

AMI_ID=$(terraform output | grep AMI_ID | awk '{print $2}' | sed -e "s/\",//g")

echo $AMI_ID