#!/bin/bash

if [ -z $SSH_KEY_PATH ]; then
    SSH_KEY_PATH="/home/ubuntu/.ssh/chave-privada.pem"
fi
# SSH_KEY_PATH="~/.ssh/key-pair-grupo7"

cd ./terraform
terraform init
terraform apply -auto-approve

EC2_TEMPLATE_DNS=$(terraform output | grep public_dns | awk '{print $2;exit}' | sed -e "s/\",//g")

# cria arquivo hosts
cat <<ANSIBLEHOSTS > ../ansible/hosts
[ec2-template-ami]
$EC2_TEMPLATE_DNS
ANSIBLEHOSTS

echo "Aguardando criação de maquinas ..."
sleep 10 # 10 segundos

cd ../ansible

echo "Executando playbook de configuração da instancia Template"
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key $SSH_KEY_PATH