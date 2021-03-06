#!/bin/bash

if [ -z $SSH_KEY_PATH ]; then
    SSH_KEY_PATH="/var/lib/jenkins/chave-privada.pem"
fi


cd 02-pipeline-AMI/terraform
terraform init -no-color
TF_VAR_ssh_key_path=$SSH_KEY_PATH terraform apply -auto-approve -no-color

EC2_TEMPLATE_DNS=$(terraform output | grep public_dns | awk '{print $2;exit}' | sed -e "s/\",//g")

# cria arquivo hosts
cat <<ANSIBLEHOSTS > ../ansible/hosts
[ec2-template-ami]
$EC2_TEMPLATE_DNS
ANSIBLEHOSTS

echo "Aguardando a criação da maquina template..."
sleep 10 # 10 segundos

cd ../ansible

echo "Executando playbook de configuração da instancia Template"
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key $SSH_KEY_PATH