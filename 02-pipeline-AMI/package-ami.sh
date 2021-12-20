#!/bin/bash

VERSAO=$(git describe --tags $(git rev-list --tags --max-count=1))

cd Build_AMI_AWS/terraform
RESOURCE_ID=$(terraform output | grep resource_id | awk '{print $2;exit}' | sed -e "s/\",//g")

cd ../terraform-ami
terraform init
TF_VAR_versao=$VERSAO TF_VAR_resource_id=$RESOURCE_ID terraform apply -auto-approve

AMI_ID=$(terraform output | grep AMI | awk '{print $2}' | sed -e "s/\",//g")

echo $AMI_ID
# echo "
# variable "image_id" {
#   type = string
#   default = "$AMI_ID"
# }
# " > ../../Build-k8s-mult-master/Build-k8s-mult-master/0-k8s/0-terraform/var_ami.tf