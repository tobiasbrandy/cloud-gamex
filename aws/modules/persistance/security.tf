
resource "aws_iam_policy" "policy_rds" {
  name = "policy-replication"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["rds:CreateDBInstanceReadReplica"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_security_group" "rds" {
  name        = "terraform_rds_security_group"
  vpc_id      = var.vpc_id
}


resource "aws_security_group_rule" "rds_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds.id
}

resource "aws_security_group_rule" "rds_in" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds.id
}