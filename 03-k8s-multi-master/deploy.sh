#!/bin/bash

# ID_M1_DNS="ubuntu@ec2-18-234-97-123.compute-1.amazonaws.com"
# ID_M1_DNS=$(echo "$ID_M1_DNS" | cut -b 8-)
# echo ${ID_M1_DNS}

#### idéia para buscar itens do debugger do ansible ####
# | grep -oP "(kubeadm join.*?certificate-key.*?)'" | sed 's/\\//g' | sed "s/'//g" | sed "s/'t//g" | sed "s/,//g"

if [ -z $ami_id ]
then
      echo "É necessário informar o ID da ami a ser utilizado."
      echo "Ex via shell: $ ami_id=\"ami-0c5babde7262e53c8\" ./deploy.sh"
      exit
fi

cd  03-k8s-multi-master/0-terraform
terraform init -no-color
TF_VAR_ami_id=$ami_id terraform apply -auto-approve -no-color

echo  "Aguardando 10 segundos para finalizar a criação das maquinas ..."
sleep 10

if [ -z $SSH_KEY_PATH ]; then
    SSH_KEY_PATH="/var/lib/jenkins/chave-privada.pem"
fi
# SSH_KEY_PATH="~/.ssh/key-pair-grupo7"

ID_M1=$(terraform output | grep 'k8s-master 1 -' | awk '{print $4;exit}')
ID_M1_DNS=$(terraform output | grep 'k8s-master 1 -' | awk '{print $9;exit}' | cut -b 8-)

ID_M2=$(terraform output | grep 'k8s-master 2 -' | awk '{print $4;exit}')
ID_M2_DNS=$(terraform output | grep 'k8s-master 2 -' | awk '{print $9;exit}' | cut -b 8-)

ID_M3=$(terraform output | grep 'k8s-master 3 -' | awk '{print $4;exit}')
ID_M3_DNS=$(terraform output | grep 'k8s-master 3 -' | awk '{print $9;exit}' | cut -b 8-)


ID_HAPROXY=$(terraform output | grep 'k8s_proxy 1 -' | awk '{print $4;exit}')
ID_HAPROXY_DNS=$(terraform output | grep 'k8s_proxy 1 -' | awk '{print $9;exit}' | cut -b 8-)


ID_W1=$(terraform output | grep 'k8s-workers 1 -' | awk '{print $4;exit}')
ID_W1_DNS=$(terraform output | grep 'k8s-workers 1 -' | awk '{print $9;exit}' | cut -b 8-)

ID_W2=$(terraform output | grep 'k8s-workers 2 -' | awk '{print $4;exit}')
ID_W2_DNS=$(terraform output | grep 'k8s-workers 2 -' | awk '{print $9;exit}' | cut -b 8-)

ID_W3=$(terraform output | grep 'k8s-workers 3 -' | awk '{print $4;exit}')
ID_W3_DNS=$(terraform output | grep 'k8s-workers 3 -' | awk '{print $9;exit}' | cut -b 8-)

echo "
[ec2-k8s-proxy]
$ID_HAPROXY_DNS

[ec2-k8s-m1]
$ID_M1_DNS
[ec2-k8s-m2]
$ID_M2_DNS
[ec2-k8s-m3]
$ID_M3_DNS

[ec2-k8s-w1]
$ID_W1_DNS
[ec2-k8s-w2]
$ID_W2_DNS
[ec2-k8s-w3]
$ID_W3_DNS
" > ../2-ansible/hosts

echo "
global
        log /dev/log    local0
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

        # Default SSL material locations
        ca-base /etc/ssl/certs
        crt-base /etc/ssl/private

        # See: https://ssl-config.mozilla.org/#server=haproxy&server-version=2.0.3&config=intermediate
        ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
        ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
        ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets

defaults
        log     global
        mode    http
        option  httplog
        option  dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
        errorfile 400 /etc/haproxy/errors/400.http
        errorfile 403 /etc/haproxy/errors/403.http
        errorfile 408 /etc/haproxy/errors/408.http
        errorfile 500 /etc/haproxy/errors/500.http
        errorfile 502 /etc/haproxy/errors/502.http
        errorfile 503 /etc/haproxy/errors/503.http
        errorfile 504 /etc/haproxy/errors/504.http

frontend kubernetes
        mode tcp
        bind $ID_HAPROXY:6443 # IP ec2 Haproxy 
        option tcplog
        default_backend k8s-masters

backend k8s-masters
        mode tcp
        balance roundrobin # maq1, maq2, maq3  # (check) verifica 3 vezes negativo (rise) verifica 2 vezes positivo
        server k8s-master-0 $ID_M1:6443 check fall 3 rise 2 # IP ec2 Cluster Master k8s - 1 
        server k8s-master-1 $ID_M2:6443 check fall 3 rise 2 # IP ec2 Cluster Master k8s - 2 
        server k8s-master-2 $ID_M3:6443 check fall 3 rise 2 # IP ec2 Cluster Master k8s - 3 
        
" > ../2-ansible/haproxy/haproxy.cfg


echo "
127.0.0.1 localhost
$ID_HAPROXY k8s-haproxy # IP privado proxy

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
" > ../2-ansible/host/hosts


cd ../2-ansible

ANSIBLE_OUT=$(ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key $SSH_KEY_PATH)

### Mac ###
K8S_JOIN_MASTER=$(echo $ANSIBLE_OUT | grep -oE "(kubeadm join.*?certificate-key.*?)'" | sed 's/\\//g' | sed "s/'t//g" | sed "s/'//g" | sed "s/,//g")
K8S_JOIN_WORKER=$(echo $ANSIBLE_OUT | grep -oE "(kubeadm join.*?discovery-token-ca-cert-hash.*?)'" | head -n 1 | sed 's/\\//g' | sed "s/'t//g" | sed "s/'//g" | sed "s/'//g" | sed "s/,//g")
### Linix ###
K8S_JOIN_MASTER=$(echo $ANSIBLE_OUT | grep -oP "(kubeadm join.*?certificate-key.*?)'" | sed 's/\\//g' | sed "s/'t//g" | sed "s/'//g" | sed "s/,//g")
K8S_JOIN_WORKER=$(echo $ANSIBLE_OUT | grep -oP "(kubeadm join.*?discovery-token-ca-cert-hash.*?)'" | head -n 1 | sed 's/\\//g' | sed "s/'t//g" | sed "s/'//g" | sed "s/'//g" | sed "s/,//g")

echo $K8S_JOIN_MASTER
echo $K8S_JOIN_WORKER

cat <<EOF > 2-provisionar-k8s-master-auto-shell.yml
- hosts:
  - ec2-k8s-m2
  - ec2-k8s-m3
  become: yes
  tasks:
    - name: "Reset cluster"
      shell: "kubeadm reset -f"

    - name: "Fazendo join kubernetes master"
      shell: $K8S_JOIN_MASTER

    - name: "Colocando no path da maquina o conf do kubernetes"
      shell: mkdir -p $HOME/.kube && sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config && sudo chown $(id -u):$(id -g) $HOME/.kube/config && export KUBECONFIG=/etc/kubernetes/admin.conf
#---
- hosts:
  - ec2-k8s-w1
  - ec2-k8s-w2
  - ec2-k8s-w3
  become: yes
  tasks:
    - name: "Reset cluster"
      shell: "kubeadm reset -f"

    - name: "Fazendo join kubernetes worker"
      shell: $K8S_JOIN_WORKER

#---
- hosts:
  - ec2-k8s-m1
  become: yes
  tasks:
    - name: "Configura weavenet para reconhecer os nós master e workers"
      shell: kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=\$(kubectl version | base64 | tr -d '\n')"

    - name: Espera 30 segundos
      wait_for: timeout=30

    - shell: kubectl get nodes -o wide
      register: ps
    - debug:
        msg: " '{{ ps.stdout_lines }}' "
EOF

ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts 2-provisionar-k8s-master-auto-shell.yml -u ubuntu --private-key $SSH_KEY_PATH

cat <<SCRIPTTESTE > ../teste.sh
#!/bin/bash
STATUS_NODES=\$(ssh -i $SSH_KEY_PATH -o ServerAliveInterval=60 -o StrictHostKeyChecking=no ubuntu@$ID_M1_DNS sudo kubectl get nodes -o wide)

if \$(echo \$STATUS_NODES| grep -q NotReady) ; then
    echo "ERRO: Um ou mais nodes com status NotReady"
else
    echo "Todos os nodes estão com status Ready"
fi
SCRIPTTESTE
chmod +x ../teste.sh