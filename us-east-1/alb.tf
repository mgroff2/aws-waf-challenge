module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.11.0"

  name    = "${var.name}-alb"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  enable_deletion_protection = false

  # Security Group
  security_groups = [module.vpc.default_security_group_id]
  security_group_ingress_rules = {
    ingress_https_from_cloudfront = {
      ip_protocol    = "-1"
      description    = "All traffic from CloudFront"
      prefix_list_id = data.aws_ec2_managed_prefix_list.cloudfront.id
    }
  }

  listeners = {
    http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Access Denied"
        status_code  = "403"
      }
      rules = {
        allow_cloudfront = {
          priority = 1
          actions = [{
            type             = "forward"
            target_group_key = "asg-tg"
          }]

          conditions = [{
            http_header = {
              http_header_name = "X-WAF-Header"
              values           = [random_string.custom_header_value.result]
            }
          }]
        }
      }
    }
  }

  target_groups = {
    asg-tg = {
      backend_protocol  = "HTTP"
      backend_port      = 80
      target_type       = "instance"
      create_attachment = false # This is required to be set to false when using with ASG
      health_check = {
        enabled             = true
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
      }
    }
  }

  tags = var.default_tags
}

data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}
