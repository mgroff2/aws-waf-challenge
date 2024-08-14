module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 5.1.0"

  domain_name         = var.domain_name
  zone_id             = var.zone_id
  validation_method   = "DNS"
  wait_for_validation = true

  subject_alternative_names = [
    "waf.${var.domain_name}",
    "*.${var.domain_name}",
  ]

}
