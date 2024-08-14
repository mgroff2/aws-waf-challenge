module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.12.1"

  create_vpc = var.create_vpc

  name = "${var.name}-vpc"
  cidr = var.cidr

  azs = var.azs

  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  enable_vpn_gateway = var.enable_vpn_gateway

  manage_default_security_group = false

  tags = var.default_tags
}

resource "aws_default_security_group" "default" {
  vpc_id = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Self-referencing security group
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  tags = var.default_tags
}
