
resource "aws_iam_policy" "policy_rds" {
  count = length(var.persistance_subnets)
  name = "replication-policy-${count.index}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["rds:CreateDBInstanceReadReplica"]
        Effect   = "Allow"
        Resource = [
          "arn:aws:rds:::replic-${count.index}"
        ]
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
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = aws_security_group.rds.id
}

resource "aws_security_group_rule" "rds_in" {
  type              = "ingress"
  from_port         =  5432 
  to_port           =  5432 
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = aws_security_group.rds.id
}