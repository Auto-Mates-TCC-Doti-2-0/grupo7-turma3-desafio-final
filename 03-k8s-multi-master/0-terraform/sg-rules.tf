resource "aws_security_group_rule" "acessos_workers_rule_ssh" {
  type             = "ingress"
  description      = "Libera acesso SSH aos worker nodes"
  from_port        = 22
  to_port          = 22
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = aws_security_group.acessos_workers.id
}
resource "aws_security_group_rule" "acessos_workers_masters" {
  type             = "ingress"
  description      = "Libera acessos dos worker nodes para os master nodes"
  from_port        = 0
  to_port          = 0
  protocol         = "all"
  source_security_group_id = aws_security_group.acessos_workers.id
  security_group_id = aws_security_group.acessos_masters.id
}

resource "aws_security_group_rule" "acessos_master_rule_tcp" {
  type             = "ingress"
  description      = "Libera acessos as portas de aplicacao via masters"
  from_port        = 30000
  to_port          = 32767
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = aws_security_group.acessos_masters.id
}
resource "aws_security_group_rule" "acessos_master_rule_ssh" {
  type             = "ingress"
  description      = "Libera acessos ssh aos master nodes"
  from_port        = 22
  to_port          = 22
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = aws_security_group.acessos_masters.id
}
resource "aws_security_group_rule" "acessos_master_hproxy" {
  type             = "ingress"
  description      = "Libera acessos full dos masters para o haproxy"
  from_port        = 0
  to_port          = 0
  protocol         = "all"
  source_security_group_id = aws_security_group.acessos_masters.id
  security_group_id = aws_security_group.acessos_haproxy.id
}
resource "aws_security_group_rule" "acessos_master_master" {
  type             = "ingress"
  description      = "Libera acessos full entre os master nodes"
  from_port        = 0
  to_port          = 0
  protocol         = "all"
  source_security_group_id = aws_security_group.acessos_masters.id
  security_group_id = aws_security_group.acessos_masters.id
}
resource "aws_security_group_rule" "acessos_master_workers" {
  type             = "ingress"
  description      = "Libera acessos full entre masters e worker nodes"
  from_port        = 0
  to_port          = 0
  protocol         = "all"
  source_security_group_id = aws_security_group.acessos_masters.id
  security_group_id = aws_security_group.acessos_workers.id
}

resource "aws_security_group_rule" "acessos_haproxy_master" {
  type             = "ingress"
  description      = "Libera acessos do haproxy para os master nodes"
  from_port        = 0
  to_port          = 0
  protocol         = "all"
  source_security_group_id = aws_security_group.acessos_haproxy.id
  security_group_id = aws_security_group.acessos_masters.id
}
resource "aws_security_group_rule" "acessos_workers_to_haproxy" {
  type             = "ingress"
  description      = "Libera acessos dos worker nodes para o haproxy"
  from_port        = 0
  to_port          = 0
  protocol         = "all"
  source_security_group_id = aws_security_group.acessos_workers.id
  security_group_id = aws_security_group.acessos_haproxy.id
}
resource "aws_security_group_rule" "acessos_haproxy_to_workers" {
  type             = "ingress"
  description      = "Libera acessos do haproxy para os worker nodes"
  from_port        = 0
  to_port          = 0
  protocol         = "all"
  source_security_group_id = aws_security_group.acessos_haproxy.id
  security_group_id = aws_security_group.acessos_workers.id
}
resource "aws_security_group_rule" "acessos_haproxy_ssh" {
  type             = "ingress"
  description      = "Libera acessos ssh ao haproxy"
  from_port        = 22
  to_port          = 22
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = aws_security_group.acessos_haproxy.id
}