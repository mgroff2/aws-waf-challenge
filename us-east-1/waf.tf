resource "aws_wafv2_web_acl" "waf" {
  name        = "${var.name}-waf"
  scope       = "CLOUDFRONT" # or "REGIONAL"
  description = "WAF with Challenge Action"

  default_action {
    allow {}
  }

  rule {
    name     = "account-challenge"
    priority = 0

    action {
      challenge {}
    }

    statement {
      byte_match_statement {
        search_string         = "accounts"
        positional_constraint = "CONTAINS"
        field_to_match {
          uri_path {}
        }
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "${var.name}-account-challenge"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "${var.name}-waf-metrics"
    sampled_requests_enabled   = false
  }

  tags = var.default_tags
}
