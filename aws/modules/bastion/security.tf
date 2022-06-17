resource "aws_security_group" "bastion" {
  name   = "bastion"
  vpc_id = var.vpc_id
  tags = {
    Name = "bastion"
  }
}

resource "aws_security_group_rule" "bastion_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_in_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.my_ips
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_in_icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}