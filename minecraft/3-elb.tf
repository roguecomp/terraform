resource "aws_s3_bucket" "log_bucket" {
  bucket = var.elb_logs_s3
}

resource "aws_lb" "public" {
  name_prefix        = var.lb_name_prefix
  internal           = true
  load_balancer_type = "network"

  access_logs {
    bucket = var.elb_logs_s3
  }

  idle_timeout = "120"
  subnets      = data.aws_subnets.public.ids
  tags = {
    Environment = var.tag
  }

  depends_on = [
    aws_s3_bucket.log_bucket
  ]
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

resource "aws_lb_target_group" "target_group_public" {
  name_prefix = var.lb_name_prefix
  port        = var.minecraft_port
  protocol    = "TCP"
  target_type = "ip"

  vpc_id = module.vpc.vpc_id
}