
################################################################################
# VPC definition
################################################################################

module "vpc_cluster" {
  source = "terraform-aws-modules/vpc/aws"

  name = "cluster_vpc"
  cidr = var.cidr

  azs             = var.azs
  private_subnets = var.privatesub
  public_subnets  = var.publicsub

  create_igw         = true
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

################################################################################
# Security Groups
################################################################################

# Docker Swarm Manager

module "sg_manager" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "manager-sg"
  description = "Security group for manager node from Docker"
  vpc_id      = module.vpc_cluster.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH ports"
      cidr_blocks = module.vpc_cluster.vpc_id
    },
    {
      from_port   = 2377
      to_port     = 2377
      protocol    = "tcp"
      description = "Management communication between managers and workers"
      cidr_blocks = module.vpc_cluster.vpc_id
    },
    {
      from_port   = 7946
      to_port     = 7946
      protocol    = "tcp"
      description = "Communication between nodes"
      cidr_blocks = module.vpc_cluster.vpc_id
    },
    {
      from_port   = 7946
      to_port     = 7946
      protocol    = "udp"
      description = "Communication between nodes"
      cidr_blocks = module.vpc_cluster.vpc_id
    },
    {
      from_port   = 4789
      to_port     = 4789
      protocol    = "udp"
      description = "Overlay traffic"
      cidr_blocks = module.vpc_cluster.vpc_id
    },
    {
      from_port   = 0
      to_port     = 0
      protocol    = 50
      description = "Protocol 50 for IPsec encryption in the overlay network"
      cidr_blocks = module.vpc_cluster.vpc_id
    },
  ]
  egress_cidr_blocks = ["0.0.0.0/0"]
}

# DOcker Swarm Worker

module "sg_worker" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "worker-sg"
  description = "Security group for manager node from Docker"
  vpc_id      = module.vpc_cluster.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH ports"
      cidr_blocks = module.vpc_cluster.vpc_id
    },
    {
      from_port   = 7946
      to_port     = 7946
      protocol    = "tcp"
      description = "Communication between nodes"
      cidr_blocks = module.vpc_cluster.vpc_id
    },
    {
      from_port   = 7946
      to_port     = 7946
      protocol    = "udp"
      description = "Communication between nodes"
      cidr_blocks = module.vpc_cluster.vpc_id
    },
    {
      from_port   = 4789
      to_port     = 4789
      protocol    = "udp"
      description = "Overlay traffic"
      cidr_blocks = module.vpc_cluster.vpc_id
    },
    {
      from_port   = 0
      to_port     = 0
      protocol    = 50
      description = "Protocol 50 for IPsec encryption in the overlay network"
      cidr_blocks = module.vpc_cluster.vpc_id
    },
  ]
  egress_cidr_blocks = ["0.0.0.0/0"]
}

# ALB

module "alb_http_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "~> 5.0"

  name        = "sg_http_alb"
  description = "Allow HTTP traffic"
  vpc_id      = module.vpc_cluster.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
}

################################################################################
# Load Balancer
################################################################################

# Load Balancer

resource "aws_lb" "nginx_lb" {
  name               = "nginx-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = module.alb_http_sg.security_group_id
  subnets            = module.vpc_cluster.public_subnets
}

# Target group

resource "aws_lb_target_group" "nginx_tg" {
  name        = "nginx-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc_cluster.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

# Listener

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.nginx_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }
}

# Attach instances to Target Group

resource "aws_lb_target_group_attachment" "nginx_attach" {
  target_group_arn = aws_lb_target_group.nginx_tg.arn
  target_id        = var.target_id_attach
  port             = 80
}
