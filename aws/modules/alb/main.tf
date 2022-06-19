resource "aws_lb" "main" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_lb.id]
  subnets            = var.subnets
}

#Dynamically create the alb target groups for app services
resource "aws_alb_target_group" "services" {
  for_each = var.services

  name        = "${each.key}-${var.internal ? "private" : "public"}-tg"
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
      // TODO(tobi): Arreglar
      values = var.internal ? ["${var.path_prefix}/${each.key}", "${var.path_prefix}/${each.key}/*", "/${each.key}", "/${each.key}/*"] : ["${var.path_prefix}/${each.key}", "${var.path_prefix}/${each.key}/*"]
    }
  }

  dynamic "condition" {
    for_each = var.internal ? [] : [1] # Solo se genera la condition si el alb es publico

    content {
      http_header {
        http_header_name = var.cdn_secret_header
        values           = [var.cdn_secret]
      }
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
  name   = var.name
  vpc_id = var.vpc_id

  # ingress {
  #   from_port         = 0
  #   to_port           = 0
  #   protocol          = "icmp"
  #   # cidr_blocks       = [var.internal ? var.vpc_cidr : "0.0.0.0/0"]
  #   cidr_blocks       = ["0.0.0.0/0"]
  # }

  # ingress {
  #   from_port         = 0
  #   to_port           = 0
  #   protocol          = "tcp"
  #   # cidr_blocks       = [var.internal ? var.vpc_cidr : "0.0.0.0/0"] // TODO(tobi)
  #   cidr_blocks       = ["0.0.0.0/0"]
  # }

  ingress {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  egress {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
  }
}
