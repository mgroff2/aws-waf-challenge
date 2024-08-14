resource "aws_route53_record" "waf" {
  zone_id = var.zone_id
  name    = "waf"
  type    = "A"
  alias {
    name                   = module.cloudfront.cloudfront_distribution_domain_name
    zone_id                = module.cloudfront.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = false
  }

}
