#!/bin/bash

# ID_M1_DNS="ubuntu@ec2-18-234-97-123.compute-1.amazonaws.com"
# ID_M1_DNS=$(echo "$ID_M1_DNS" | cut -b 8-)
# echo ${ID_M1_DNS}

#### idéia para buscar itens do debugger do ansible ####
# | grep -oP "(kubeadm join.*?certificate-key.*?)'" | sed 's/\\//g' | sed "s/'//g" | sed "s/'t//g" | sed "s/,//g"

if [ -z $SSH_KEY_PATH ]; then
    SSH_KEY_PATH="~/.ssh/key-pair-grupo7"
fi

cd 00-terraform
terraform init
TF_VAR_ssh_pub_key_path="$SSH_KEY_PATH.pub" terraform apply -auto-approve

SLEEPTIME=5
echo  "Aguardando $SLEEPTIME segundos para finalizar a criação da instancia do Jenkins ..."
sleep $SLEEPTIME

cd ../01-ansible

ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key $SSH_KEY_PATH --extra-vars "ssh_key_path=$SSH_KEY_PATH"