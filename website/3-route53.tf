resource "aws_route53_record" "www" {
  zone_id = "Z02024842F73WIP3EA0PB"
  name    = var.www_url
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "dns" {
  zone_id = "Z02024842F73WIP3EA0PB"
  name    = var.url
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}