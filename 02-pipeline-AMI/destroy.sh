#!/bin/bash

destroy_ami() {
    VERSAO=$(git describe --tags $(git rev-list --tags --max-count=1))

    cd ./terraform
    RESOURCE_ID=$(terraform output | grep resource_id | awk '{print $2;exit}' | sed -e "s/\",//g")

    cd ../terraform-ami
    terraform init
    TF_VAR_versao=$VERSAO TF_VAR_resource_id=$RESOURCE_ID terraform destroy -auto-approve

    cd ..
}

if [ "$DESTROY_AMI" = true ] ; then
    destroy_ami
fi

cd ./terraform
terraform destroy -auto-approve