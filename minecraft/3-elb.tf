resource "aws_security_group" "public_lb_access" {
  description = "Allow access to the public facing load balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "allow public access to fargate ECS"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.remote_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.remote_cidr_blocks
  }

  tags = {
    Name = var.tag
  }
}

resource "aws_lb" "public" {
  name_prefix        = var.lb_name_prefix
  internal           = true
  load_balancer_type = "network"
  idle_timeout       = "30"
  security_groups    = [aws_security_group.public_lb_access.id]
  subnets            = data.aws_subnets.public.ids
  tags = {
    Environment = var.tag
  }
}

resource "aws_lb_listener" "public_listener" {
  load_balancer_arn = aws_lb.public.arn
  port              = var.minecraft_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_public.arn
  }
}

resource "aws_lb_listener_rule" "public" {
  listener_arn = aws_lb_listener.public_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_public.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

resource "aws_lb_target_group" "target_group_public" {
  name_prefix = var.lb_name_prefix
  port        = var.minecraft_port
  protocol    = "TCP"
  target_type = "ip"

  vpc_id = module.vpc.vpc_id
}