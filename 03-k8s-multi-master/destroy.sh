#!/bin/bash

cd  03-k8s-multi-master/0-terraform
terraform init -no-color
TF_VAR_ami_id=$(terraform output ami_id) terraform destroy -auto-approve -no-color