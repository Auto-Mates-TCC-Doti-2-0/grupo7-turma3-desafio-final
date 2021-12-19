# Desafio Treinamento Devops Grupo Auto-Mates
</h3>
<p align="center">
 <a href="#objetivodoprojeto">Objetivo do projeto</a> |
 <a href="#desenvolvedores">Desenvolvedores</a> |
 <a href="#tecnologias">Tecnologias</a> |
 <a href="#descriçãodoprojeto">Descrição do projeto</a> |
 <a href="#prerequisitos">Pré requisitos</a> |
 <a href="#utilização">Utilização</a> |
 <a href="#agradecimento">Agradecimento</a>
</p>

**Status do Projeto: Concluido :heavy_check_mark:**

## Objetivo do projeto

Exercitar os conhecimentos adquiridos do treinamento da Gama Academy:

-  Criar uma **rede isolada** para a aplicação;

-  Criar uma **pipeline de infraestrutura** para provisionar uma imagem que será utilizada em um cluster kubernetes(**multi master**);
-  Criar uma **Pipeline** para provisionar um cluster **Kubernetes** multi master utilizando a imagem criada na pipeline de infraestrutura;
- Criar uma pipeline para provisionar o **banco de dados** (dev, stage, prod) que será utilizado nas aplicações que estarão no kubernetes. Esta base de dados, será provisionada em uma instância privada, com acesso a Internet via **Nat Gateway** na mesma vpc do kubernetes multi master;
-  Criar uma **Pipeline** de desenvolvimento para **deployar os ambientes de uma aplicação Java** (dev, stage, prod) com ligação a um banco de dados mysql-server (utilizar o cluster kubernetes(multi master) provisionado pela pipeline de infraestrutura.
  
Para acessar o **repositório do projeto**, clique aqui: [grupo7-turma3-desafio-final](https://github.com/Auto-Mates-TCC-Doti-2-0/grupo7-turma3-desafio-final)</br>

### Desenvolvedores
|<sub>[<img src="https://avatars.githubusercontent.com/u/15928493?v=4" width=115 > <br> <sub> Leonardo Contini </sub>](https://github.com/lcontini?tab=repositories) | [<img src="https://avatars.githubusercontent.com/u/67441115?v=4" width=115 > <br> <sub> Lúcio José Cabianca </sub>](https://github.com/LUJOCALX?tab=repositories) </sub><br>
| -------- | -------- |

## Tecnologias Utilizadas

Plataformas e Tecnologias que utilizamos para desenvolver este projeto:

- [AWS](https://aws.amazon.com/)
- [Linux (Ubuntu)](https://ubuntu.com/)
- [Shell Script](https://www.gnu.org/software/bash/)
- [Terraform](https://www.terraform.io/)
- [Ansible](https://www.ansible.com/)
- [Docker](https://www.docker.com/)
- [Kubernetes](https://kubernetes.io/)
- [Jenkins](https://www.jenkins.io/)
- [Mysql](https://www.mysql.com//)
- [Java](https://www.java.com/)
- [Git](https://www.github.com/)

## Descrição do Projeto

  Construção de pipelines de desenvolvimento, stage e produção, com tecnologias estudadas no treinamento, para provisionar um cluster K8s multi master onde é feito o deployment de uma aplicação Java Spring Boot que acessa o banco de dados mysql em uma rede privada.
  
### Como Executar:

**1.** Faça o **clone** do repositorio abaixo para sua maquina;

(https://github.com/Auto-Mates-TCC-Doti-2-0/grupo7-turma3-desafio-final)

**2.** Dentro da pasta **"01-infra-principal"** execute o shell **deploy.sh**;

**3.** Informe o caminho da **chave privada** no comando (**Ex:** $ **./deploy.sh /home/ubuntu/id_rsa**);

**4.** Aguarde a **"mágica"** acontecer 😁

### Agradecimentos
- Ao [**Danilo Aparecido**](https://github.com/didox) e **Regina** da **Gama** por todo o apoio;
- Ao **Itaú/DOTI** e aos **colegas do treinamento** que contribuiram bastante para um aprendizado ainda maior;