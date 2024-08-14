
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "8.0.0"

  # Autoscaling group
  name                = "${var.name}-asg"
  vpc_zone_identifier = module.vpc.private_subnets
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  health_check_type   = var.health_check_type

  # Security group
  security_groups = [module.vpc.default_security_group_id]

  # Launch template
  launch_template_name        = "${var.name}-lt"
  launch_template_description = "Launch template for ${var.name}-asg"
  update_default_version      = true

  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  ebs_optimized     = var.ebs_optimized
  enable_monitoring = var.enable_monitoring

  # IAM role & instance profile
  create_iam_instance_profile = true
  iam_role_name               = "${var.name}-asg-role"
  iam_role_description        = "IAM role for ${var.name}-asg"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  user_data = base64encode(local.user_data)

  traffic_source_attachments = {
    alb = {
      traffic_source_identifier = module.alb.target_groups["asg-tg"].arn
      traffic_source_type       = "elbv2"
    }
  }

  tags = var.default_tags
}

# Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*x86_64-ebs"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}
