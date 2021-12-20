#!/bin/bash

if [ -z $SSH_KEY_PATH ]; then
    SSH_KEY_PATH="/home/ubuntu/.ssh/chave-privada.pem"
fi

cd ./ansible
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts mysql.yml -u ubuntu --private-key $SSH_KEY_PATH --extra-vars "USER=$USER PASSWORD=$PASSWORD DATABASE=$DATABASE"