#!/bin/bash

cd 00-terraform
terraform init
terraform destroy -auto-approve