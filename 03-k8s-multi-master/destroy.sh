#!/bin/bash

cd 0-terraform
terraform init
TF_VAR_ami_id=$(terraform output ami_id) terraform destroy -auto-approve