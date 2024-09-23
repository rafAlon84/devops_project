
################################################################################
# Autoscaling Group
################################################################################

# Launch Template

resource "aws_launch_template" "packer-image" {
  name                                 = "packer-template"
  image_id                             = "ami-test"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"
  key_name                             = "worker-node"
  monitoring {
    enabled = true
  }
  placement {
    availability_zone = "eu-west-1a"
  }
  vpc_security_group_ids = [module.networking.sg_worker_id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "test"
    }
  }
}

# ASG

resource "aws_autoscaling_group" "app_asg_worker" {
  availability_zones  = ["eu-west-1a"]
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = module.networking.private_subnet_id

  launch_template {
    id      = aws_launch_template.packer-image.id
    version = "$Latest"
  }
}
