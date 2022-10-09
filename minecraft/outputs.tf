output "public_subnet_ids" {
  value = data.aws_subnets.public.ids
}

output "private_subnet_ids" {
  value = data.aws_subnets.private.ids
}

output "aws_lb_zone_id" {
  value = aws_lb.public.zone_id
}