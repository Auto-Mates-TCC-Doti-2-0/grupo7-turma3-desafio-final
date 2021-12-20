#!/bin/bash

destroy_ami() {
    VERSAO=$(git describe --tags $(git rev-list --tags --max-count=1))

    cd 02-pipeline-AMI/terraform
    RESOURCE_ID=$(terraform output | grep resource_id | awk '{print $2;exit}' | sed -e "s/\",//g")

    cd ../terraform-ami
    terraform init -no-color
    TF_VAR_versao=$VERSAO TF_VAR_resource_id=$RESOURCE_ID terraform destroy -auto-approve -no-color

    cd ../..
}

if [ "$DESTROY_AMI" = true ] ; then
    destroy_ami
fi

cd 02-pipeline-AMI/terraform
terraform destroy -auto-approve -no-color