#!/bin/bash

cd 04-deploy-mysql/terraform
terraform init -no-color
TF_VAR_ami_id=$(terraform output ami_id) terraform destroy -auto-approve -no-color