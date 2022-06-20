resource "aws_ecs_cluster" "main" {
  name = "services-cluster"
}

resource "aws_ecs_task_definition" "main" {
  for_each = var.services

  family = each.key
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([{
    name        = "${each.key}-container"
    image       = lookup(var.service_images, each.key, "invalid")
    essential   = true
    environment = var.environment

    portMappings = [{
      protocol      = "tcp"
      containerPort = 80
    }]
  }])
}

# Nota: Ideal hacer el service descovery con esto, pero no tenemos permisos :(((
resource "aws_ecs_service" "main" {
  for_each = var.services

  name                               = "${each.key}-service"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.main[each.key].arn
  desired_count                      = 3
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  
  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = var.app_subnets
    assign_public_ip = false
  }
  
  load_balancer {
    target_group_arn = var.public_alb_target_groups[each.key].arn
    container_name   = "${each.key}-container"
    container_port   = 80
  }

  load_balancer {
    target_group_arn = var.internal_alb_target_groups[each.key].arn
    container_name   = "${each.key}-container"
    container_port   = 80
  }
  
  lifecycle {
    ignore_changes = [desired_count]
  }
}

resource "aws_security_group" "ecs_tasks" {
  name   = "ecs-sg"
  vpc_id = var.vpc_id

    ingress {
    from_port         = 0
    to_port           = 0
    protocol          = "icmp"
    cidr_blocks       = [var.vpc_cidr]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = [var.vpc_cidr]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = [var.vpc_cidr]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
