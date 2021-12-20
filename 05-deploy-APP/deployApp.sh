#!/bin/bash

environment=$1

if [ $environment != "dev" ] && [ $environment != "stage" ] && [ $environment != "prod" ]; then
    echo "o parametro ambiente deve ser dev, stage ou prod"
    exit
fi

if [ -z $SSH_KEY_PATH ]; then
    SSH_KEY_PATH="/var/lib/jenkins/chave-privada.pem"
fi

echo "configurando arquivo de hosts do ansible"
cd 03-k8s-multi-master/0-terraform
K8S_MASTER_1=$(terraform output | grep 'k8s-master 1 -' | awk '{print $9;exit}' | cut -b 8-)
cd ../..

cd 05-deploy-APP/ansible
cat <<ANSIBLEHOSTS > hosts
[k8s-master-1]
$K8S_MASTER_1
ANSIBLEHOSTS
cd ../..

echo "injetando host mysql no configmap"
cd 04-deploy-mysql/terraform
MYSQL_IP=$(terraform output | grep "ec2-mysql-$environment" | awk '{print $3;exit}')
cd ../..

cd 05-deploy-APP/ansible
cat <<ANSIBLEPLAYBOOK > k8s-deploy/mysql-configmap-$environment.yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-configmap-$environment
data:
  USER: root
  DATABASE_URL: mysql://$MYSQL_IP:3306/SpringWebYoutube?useTimezone=true&serverTimezone=UTC&createDatabaseIfNotExist=true
ANSIBLEPLAYBOOK

echo "Executando playbook ansible"
echo "$environment"
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionarApp.yml -u ubuntu --private-key $SSH_KEY_PATH --extra-vars "environment=$environment"
