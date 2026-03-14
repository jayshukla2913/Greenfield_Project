resource "aws_lb" "alb" {

  name               = "greenfield-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [var.alb_sg]
  subnets         = var.public_subnets
}

resource "aws_lb_target_group" "tg" {

  name     = "greenfield-tg"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/health"
  }

}

resource "aws_lb_listener" "listener" {

  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {

    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn

  }

}