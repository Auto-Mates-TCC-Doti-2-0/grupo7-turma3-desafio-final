
resource "aws_security_group" "acessos_mysql" {
  name        = "acessos_mysql"
  description = "acessos inbound traffic"
  vpc_id = data.terraform_remote_state.infra_principal_remote_state.outputs.vpc_id
  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null,
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      cidr_blocks      = []
      description      = "Libera acesso dos workers e masters para o mysql"
      from_port        = 3306
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = [data.terraform_remote_state.infra_k8s_nodes.outputs.k8s_master_sg_id, data.terraform_remote_state.infra_k8s_nodes.outputs.k8s_worker_sg_id, data.terraform_remote_state.infra_principal_remote_state.outputs.sg_jenkins_id]
      self             = false
      to_port          = 3306
    },
    
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = [],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "acessos_mysql"
    Group = "Grupo7"
  }
}
