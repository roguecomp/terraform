resource "aws_route53_zone" "minecraft_dns_name" {
  name = var.minecraft_url
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.minecraft_dns_name.zone_id
  name    = var.minecraft_url
  type    = "A"

  alias {
    name                   = aws_lb.public.dns_name
    zone_id                = aws_lb.public.zone_id
    evaluate_target_health = true
  }
}
