#!/bin/bash

cd 00-terraform
terraform init
TF_VAR_ssh_pub_key_path=$(terraform output ssh_pub_key_path | tr -d "\"" ) terraform destroy -auto-approve