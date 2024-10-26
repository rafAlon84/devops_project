
################################################################################
# Autoscaling Group for app's worker
################################################################################

# Launch Template

resource "aws_launch_template" "packer-image" {
  name                                 = "packer-template"
  image_id                             = var.ami_id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.size_instance_worker
  key_name                             = "worker-node"
  monitoring {
    enabled = true
  }
  placement {
    availability_zone = "eu-west-3a"
  }
  vpc_security_group_ids = [var.worker_id_sg]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Docker-app"
    }
  }
}

# ASG

resource "aws_autoscaling_group" "app_asg_worker" {
  availability_zones  = var.azs_ids
  desired_capacity    = var.asg_desired
  max_size            = var.asg_max
  min_size            = var.asg_min
  vpc_zone_identifier = [var.private_subnet]

  launch_template {
    id      = aws_launch_template.packer-image.id
    version = "$Latest"
  }
}

################################################################################
# EC2 Instances
################################################################################
# In the future, I'm planning to add Auto Scaling Groups for the other worker 
# nodes and manager node to add availability and fault tolerance

# Worker nodes for monitoring and load balancing (common workers)

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["monitoring", "nginx-lb"])

  name            = "Docker-${each.key}"
  launch_template = aws_launch_template.packer-image
}

# Manager node

resource "aws_instance" "manager_instance" {
  ami                    = var.ami_id
  instance_type          = var.size_instance_manager
  subnet_id              = var.private_subnet
  vpc_security_group_ids = [var.worker_id_sg]
  tags = {
    Name = "Docker-manager"
  }
}
