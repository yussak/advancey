resource "aws_lb" "alb" {
  name               = "alb"
  load_balancer_type = "application"
  internal           = false
  idle_timeout       = 60
  # enable_deletion_protection = true

  subnets = [
    aws_subnet.public-1a.id,
    aws_subnet.public-1c.id,
  ]

  security_groups = [
    module.http_sg.security_group_id,
    module.https_sg.security_group_id,
    module.http_redirect_sg.security_group_id,
  ]
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "これは『HTTP』です"
      status_code  = "200"
    }
  }
}

# ターゲットグループ #########################################
resource "aws_lb_target_group" "test" {
  name                 = "test"
  target_type          = "ip"
  vpc_id               = aws_vpc.vpc.id
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 300

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  depends_on = [aws_lb.alb]
}

resource "aws_lb_listener_rule" "test" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }

  condition {
    # field  = "path-pattern"
    # values = ["/*"]
    path_pattern {
      values = ["/*"]
    }
  }
}
