module "networking" {
  source           = "./networking"
  cidr             = var.cidr-vpc     # Your VPC CIDR
  azs              = var.azs_list     # Put your azs
  privatesub       = var.private-cidr # Put your private subnets CIDRs
  publicsub        = var.public-cidr  # Put your public subnets CIDRs
  target_id_attach = lookup(module.nodes.common_workers_id, "nginx-lb", null).id
}

module "nodes" {
  source                = "./nodes"
  ami_id                = var.id_ami # Your AMI id
  size_instance_manager = var.manager_size_instance
  size_instance_worker  = var.worker_size_instance
  azs_ids               = var.azs_list
  asg_desired           = var.asg_desired_size
  asg_max               = var.asg_max_size
  asg_min               = var.asg_min_size
  manager_id_sg         = module.networking.sg_manager_id
  worker_id_sg          = module.networking.sg_worker_id
  private_subnet        = module.networking.private_subnet_id
}
