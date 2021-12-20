#!/bin/bash

if [ -z $SSH_KEY_PATH ]; then
    SSH_KEY_PATH="/home/ubuntu/.ssh/chave-privada.pem"
fi

cd ./terraform
terraform init
TF_VAR_ssh_key_path=$SSH_KEY_PATH TF_VAR_ami_id=$ami_id terraform apply -auto-approve

echo  "Aguardando a criação das maquinas ..."
sleep 10

ID_DEV=$(terraform output | grep "ec2-mysql-dev -" | awk '{print $3}')
ID_STAGE=$(terraform output | grep "ec2-mysql-stage -" | awk '{print $3}')
ID_PROD=$(terraform output | grep "ec2-mysql-prod -" | awk '{print $3}')


cat <<ANSIBLEHOSTS > ../ansible/hosts
[ec2-mysql-dev]
$ID_DEV
[ec2-mysql-stage]
$ID_STAGE
[ec2-mysql-prod]
$ID_PROD
ANSIBLEHOSTS

# cat <<SCRIPTTESTE > ../teste.sh
# #!/bin/bash
# cd ./terraform
# for i in $ID_DEV $ID_STAGE $ID_PROD; do
#     \$VALIDA_MYSQL=\$(terraform output | grep \$i | sed -e "s/\",//g" | awk -F' - ' '{print \$3" \"mysql -u$USER -p$PASSWORD $DATABASE --execute=\'select * from administradores;\'\""}' | sh)
#     if \$(echo \$VALIDA_MYSQL| grep -q grupo7) ; then
#         echo "Instancia \$i e dump validados com sucesso"
#     else
#         echo "Falha na criacao da instancia ou na restauracao do dump"
#     fi
# done
# SCRIPTTESTE
# chmod +x ../teste.sh