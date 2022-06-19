resource "aws_lb" "main" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_lb.id]
  subnets            = var.public_subnets
}

#Dynamically create the alb target groups for app services
resource "aws_alb_target_group" "services" {
  for_each = var.services

  name        = "${each.key}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  # health_check {
  #   path = each.value.health_check_path
  #   protocol = each.value.protocol
  # }
}

# resource "aws_alb_listener" "http" {
#   load_balancer_arn = aws_lb.main.id
#   port              = 80
#   protocol          = "HTTP"
 
#   default_action {
#    type = "redirect"
 
#    redirect {
#      port        = 443
#      protocol    = "HTTPS"
#      status_code = "HTTP_301"
#    }
#   }
# }

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main.id

  port      = 80
  protocol  = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      status_code  = "403"
      message_body = jsonencode({
        error = "Forbidden"
      })
    }
  }
}

# Redirigimos a cada servicio segun ruta
resource "aws_alb_listener_rule" "services" {
  for_each = var.services

  listener_arn = aws_alb_listener.http.arn

  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.services[each.key].arn
  }
  
  condition {
    path_pattern {
      values = ["${var.path_prefix}/${each.key}"]
    }
  }

  condition {
    http_header {
      http_header_name = var.cdn_secret_header
      values           = [var.cdn_secret]
    }
  }
}

# resource "aws_alb_listener" "https" {
#   load_balancer_arn = aws_lb.main.id
#   port              = 443
#   protocol          = "HTTPS"
 
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.alb_tls_cert_arn
 
#   default_action {
#     target_group_arn = aws_alb_target_group.main.id
#     type             = "forward"
#   }
# }

resource "aws_security_group" "ecs_lb" {
  name   = "app-alb"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "ecs_lb_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_lb.id
}

resource "aws_security_group_rule" "ecs_lb_in_icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_lb.id
}

resource "aws_security_group_rule" "ecs_lb_in_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_lb.id
}
